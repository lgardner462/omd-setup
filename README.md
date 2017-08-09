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

> https://mathias-kettner.de/checkmk_configvars.html 

=============================================================================================================================================


The checkmk-setup.sh script will automatically cause all of our services to have the same service group as the hostgroup of the host it was assigned, this is generally what we would like, this makes tracking certain services easier, however sometimes we have a non-critical service on a critical24x7 host (such as Check_MK) that sends us pages in the middle of the night. This is where "Service levels" come in, service levels are similar to service groups, but a service can only have one given service level at a time, while it can have multiple service groups. This makes overwriting the service level on a service by service basis much easier. Our service notifications are based on "Service level" rather than "Service Group" which is used for organizational purposes.



This assigns our service levels based on our host criticality tags
<code>extra_service_conf.setdefault('_ec_sl', []) 

extra_service_conf['_ec_sl'] = [
  ( 10, ['engaging-basic', ], ALL_HOSTS, ALL_SERVICES ),
  ( 20, ['engaging-critical', ], ALL_HOSTS, ALL_SERVICES ),
  ( 30, ['engaging-critical-24x7', ], ALL_HOSTS, ALL_SERVICES ),
      ] + extra_service_conf['_ec_sl']
</code>

We can overwrite this default value on a service by service basis, this following command makes Check_MK a basic service on all hosts

extra_service_conf.setdefault('_ec_sl', []) 

extra_service_conf['_ec_sl'] = [
  ( 10, ALL_HOSTS, ['Check_MK$'] ),
      ] + extra_service_conf['_ec_sl']




Note that check_mk prioritizes files found at lower deeper in the wato folder, so if you have two conflicting service levels, the rule in the deepest level will be applied. If a service level is changed multiple times on the same level, the one which was applied last will be assigned. This is why we keep the generic rules in the top level wato directory with host specific ones in the deeper host specific subdirectories.   


=============================================================================================================================================


Active checks 

Active checks can be created in subdirectories as well, these have a bit more syntax to them since they are a WATO thing more than a simple check_mk item. (As a general rule if you see the FOLDER_PATH there is a good chance this is a WATO item)

<code>active_checks.setdefault('dns', [])

active_checks['dns'] = [
  ( ('node001.cm.cluster', {'server': None}), ['/' + FOLDER_PATH + '/+'], ['service001'] ),
] + active_checks['dns']</code>


A list of all supported check_mk checks can be found by running the command cmk -L when logged in as the omd user

=============================================================================================================================================


Passive checks

When a host is added check_mk will perform a quick inventory of the host and will automatically pick checks based on the hardware.

We can also add in host based checks with mrpe. This has two parts, first you must edit the mrpe.cfg on the host, this is located at:

> /etc/check-mk-agent/mrpe.cfg  

In this file you would write the name of your check, as well as the command that your check will run eg

> check_lfs   /usr/lib64/nagios/plugins/check_lfs -w 96% -c 97%

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

> https://mathias-kettner.de/checkmk_inventory.html



<code>ignored_services += [

# These are autofs mounts and we shouldn't monitor them
( ALL_HOSTS, [ 'NFS mount /run/*' ] ),
# use name here
 ( [ 'testhost1','testhost2' ], ['Postfix Queue' ]),
]</code>

we can also use the inventory_df_exclude_fs command to ignore certain file systems outright

<code>inventory_df_exclude_fs += [

'tmpfs',

]</code>
=============================================================================================================================================


Setting custom thresholds for checks 

We can also set custom thresholds for certain checks in check_mk, as many of the nagios plugins have checks where the default is too low for certain environments. To do this we simply append to the checks list in a checks.mk file

<code>checks = [
 ( ALL_HOSTS, "logins", None, (150, 200) ),
 ( "testhost", "cpu.threads", None, (5000, 7000) ),
(["test-basic"],ALL_HOSTS , df , / , (80,90) ), 
]</code>


Each check is written as a python tuple with 4-5 parameters

In the first example we say that the check "logins" should be run on ALL_HOSTS, with the thresholds of 150 for warn and 200 for crit
In the second example we specify that the check "cpu.threads" should have a threshold of 5000 threads for warn and 7000 for crit, but this only applies to the host "testhost"
In the last example we use the optional first argument and specify host tags, this line says ALL_HOSTS with the host tag "test-basic" run the df check on / with the thresholds 80 and 90 percent for warn and crit respectively. 


If you are unsure if your check needs certain parameters or what the default parameters are you can check 

> /omd/sites/<site>/var/check_mk/autochecks/<hostname>.mk 

to see what check is being performed, also you can check

> /omd/versions/<version>/share/check_mk/checks/<checkname> 

to see what the default values are


=============================================================================================================================================



To remove a check from check_mk without re-inventorizing ( to check old state vs new state in power outage )

When logged in as OMDuser 

> su - engaging

Remove the line in 

> ~/var/check_mk/autochecks/<hostname>.mk

That corresponds to the check, then run 

> cmk -O


===================================================================================================

Dealing with slow host checks

Sometimes our check_mk mrpe checks will not work on slower hosts with slower checks, this is usually caused by one or more raid checks taking too long to respond. We an use local checks for these. To get the proper directory for local checks on the target host, we do the following from the site user on the noc.

> cmk -d eofe1.cm.cluster | head -10

The directory we are looking for is called "LocalDirectory"

on this is by default /usr/share/check-mk-agent/local

You would then create a dir who's name would be how many seconds you want between checks. e.g.

<code> /usr/share/check-mk-agent/local/900 </code> 

would run the scripts inside every 900 seconds, OMD will cache the output and check the cache for checks if your check_interval is lower than the script run time.

These scripts are different from nagios plugins because the output must be formatted in a certain way. The first field would be the nagios exit code number of 0,1,2, or 3. The second field is the name of the check that appaers in check_mk, the third field is performance data, or a - if you do not have performance data. The fourth is the status of the check in text "OK/WARNING/CRITICAL/UNKNOWN". The fifth is the output of the check. There are some examples on eofe1 for the osts if needed.


#########################################################################


Different thresholds for public vs private filespace

In ~/etc/check_mk/conf.d/wato/rules.mk

checkgroup_parameters.setdefault('filesystem', [])

checkgroup_parameters['filesystem'] = [
  ( {'levels': (75.0, 95.0)}, [], ALL_HOSTS, [u'<public-fs-name>'] ),
  ( {'levels': (95.0, 96.0)}, [], ALL_HOSTS, ALL_SERVICES ),
] + checkgroup_parameters['filesystem']



If we monitor any other public fs we just put them in after <public-fs-name> like

  ( {'levels': (75.0, 95.0)}, [], ALL_HOSTS, [u'<public-fs-name1>',u'<public-fs-name2>'] ), 
