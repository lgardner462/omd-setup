Setting up OMD on new VM

1) scp/salt/git/whatever the folder with .mk files and scripts to the new host (currently on my laptop)

2) cd <foldername> && ./omd-setup.sh <site name>


The above must be done as root with $1 being the name of the site you wish to create eg.

 ./omd-setup.sh c3ddb    

would make an omd site called c3ddb, the script will error and exit without running if user is not root.

4) su - <site name> && cd ~/tssetup 

5) ./checkmk-setup <contractname> <adminpassword>

This will setup
* notifications
* host/service groups 
* contacts
* timeperiods
* non-host specific checks
* login information for <contract>-admin 
* machine user to remotely acknowledge hosts/services
* a <contract>-view account that allows view only access

Included in the directory is a script to remotely acknowledge host and service problems, this requires a machine user to be setup for automation purposes but our OMD setup script does that as well. 


=================================================================================================================================


Before attempting to add hosts to check_mk make sure that each host has the check-mk-agent installed, also make sure to restart xinetd 

Hosts can be added using the addhost.sh script, this script requires you to pass a criticality flag with either the -b,-c,or -x flags for basic, critical and critical24x7 respectively, there is also a -p flag for creating a ping-only host. The script will automatically run cmk -II ; cmk -O so check_mk can gather hw/sw inventory information for the new hosts. If you do not want this for some reason e.g. you are looping through a list of hosts to add, you can pass the -n flag for no-reloads.


By default the rules we have setup will assign the criticality of the host to all of the host's services. 


Each host is given it's own subdirectory, with it's own hosts.mk file, with host specific rules.mk files being optional, this rules.mk file lets you set host specific service parameters

For example if I want to change the service "Check_MK" on a critical host from a critical service to a basic service I would create a rules.mk file in /omd/sites/<sitename>/etc/check_mk/conf.d/wato/critical/<hostname>/rules.mk and add in the host specific changes there.

All of the checkmk .mk files are written in Python, with the major variables such as host_groups and service_groups as well as others being kept in large lists,

a list of most of these variables can be found at 

https://mathias-kettner.de/checkmk_configvars.html 

=============================================================================================================================================


The checkmk-setup.sh script will automatically cause all of our services to have the same service group as the hostgroup of the host it was assigned, this is generally what we would like, however sometimes we have a non-critical service on a critical24x7 host (such as Check_MK) that sends us pages in the middle of the night. For this we would simply change that service to a basic service by editing the rules.mk file in that host's subdirectory.

service_groups = [
  ( 'test-basic', ['/' + FOLDER_PATH + '/+'], ['testhost'], [u'Check_MK$'] ),
] + service_groups

Notice that the service is simply appended to the existing service_groups list that check_mk already uses. This will assign the service_group of 'test-basic' to service 'Check_MK' only the host 'testhost'

Note that check_mk prioritizes files found at lower deeper in the wato folder, so if you have two conflicting rules, the rule in the deepest level will be applied, while conflicting rules on the same level will both be applied. This is why we keep the generic rules in the top level wato directory with host specific ones in the deeper host specific subdirectories.   


=============================================================================================================================================


Active checks 

Active checks can be created in subdirectories as well, these have a bit more syntax to them since they are a WATO thing more than a simple check_mk item. (As a general rule if you see the FOLDER_PATH there is a good chance this is a WATO item)

active_checks.setdefault('dns', [])

active_checks['dns'] = [
  ( ('node001.cm.cluster', {'server': None}), ['/' + FOLDER_PATH + '/+'], ['service001'] ),
] + active_checks['dns']


A list of all supported check_mk checks can be found by running the command cmk -L when logged in as the omd user


=============================================================================================================================================


Passive checks

When a host is added check_mk will perform a quick inventory of the host and will automatically pick checks based on the hardware.

We can also add in host based checks with mrpe. This has two parts, first you must edit the mrpe.cfg on the host, this is located at:

 /etc/check-mk-agent/mrpe.cfg  

In this file you would write the name of your check, as well as the command that your check will run eg

check_lfs   /usr/lib64/nagios/plugins/check_lfs -w 96% -c 97%

with check_lfs being then name for the check and /usr/lib64/nagios/plugins/check_lfs -w 96% -c 97% being the command you want the check to run (note the absolute path)

The second step is to reload the inventory on the monitoring host with cmk -II <hostname>; cmk -O



A list of all supported check_mk checks can be found by running the command cmk -L when logged in as the omd user


=============================================================================================================================================



Ignoring services and checks

Sometimes check_mk will automatically detect services we don't want to monitor, ignoring these is simple, we append our ignored services to the ignored_services list in a checks.mk file, note you can specify hosts explicitly or simply use ALL_HOSTS,  

We have a few different options for ignoring checks:

ignored_checktypes =  Simple list of checktypes to exclude from inventory
ignored_services  =  Host specific configuration list of service names to exclude
ignored_checks  = Host specific configuration list of checktypes to exclude

more info available here 

https://mathias-kettner.de/checkmk_inventory.html



ignored_services += [

# These are autofs mounts and we shouldn't monitor them
( ALL_HOSTS, [ 'NFS mount /run/*' ] ),
# use name here
 ( [ 'testhost1','testhost2' ], ['Postfix Queue' ]),
]

we can also use the inventory_df_exclude_fs command to ignore certain file systems outright

inventory_df_exclude_fs += [

'tmpfs',

]

=============================================================================================================================================


Setting custom thresholds for checks 

We can also set custom thresholds for certain checks in check_mk, as many of the nagios plugins have checks where the default is too low for certain environments. To do this we simply append to the checks list in a checks.mk file

checks = [
 ( ALL_HOSTS, "logins", None, (150, 200) ),
 ( "testhost", "cpu.threads", None, (5000, 7000) ),
(["test-basic"],ALL_HOSTS , df , / , (80,90) ), 
]


Each check is written as a python tuple with 4-5 parameters

In the first example we say that the check "logins" should be run on ALL_HOSTS, with the thresholds of 150 for warn and 200 for crit
In the second example we specify that the check "cpu.threads" should have a threshold of 5000 threads for warn and 7000 for crit, but this only applies to the host "testhost"
In the last example we use the optional first argument and specify host tags, this line says ALL_HOSTS with the host tag "test-basic" run the df check on / with the thresholds 80 and 90 percent for warn and crit respectively. 


If you are unsure if your check needs certain parameters or what the default parameters are you can check 

/omd/sites/<site>/var/check_mk/autochecks/<hostname>.mk 

to see what check is being performed, also you can check

/omd/versions/<version>/share/check_mk/checks/<checkname> 

to see what the default values are


=============================================================================================================================================
