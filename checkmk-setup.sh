#!/bin/bash



show_help () {
  
    echo "\$1 is contract name and \$2 is the admin login password"
    exit
}


###################run as site user eg run as nodes on omd site nodes

if [ $# -eq 0 ]
  then
    echo "No arguments supplied, \$1 is contract name, \$2 is the admin login password"
    exit 1
fi

while getopts "h|\?" o;do
	case "$o" in
		h)
			show_help
			exit 0
			;;
	esac
done	


if [[ $EUID -ne 0 ]];then
	site=$(whoami)
#	echo $EUID
#	echo $site
else
	echo "Script must be run as OMD user"
	exit 1
fi
contract=$1
password=$2
adminname=$contract-admin
sed "s/tsstuff/$contract/g" contacts.mk > /omd/sites/$site/etc/check_mk/conf.d/wato/contacts.mk 
sed "s/tsstuff/$contract/g" checks.mk > /omd/sites/$site/etc/check_mk/conf.d/wato/checks.mk
sed "s/tsstuff/$contract/g" groups.mk > /omd/sites/$site/etc/check_mk/conf.d/wato/groups.mk
sed "s/tsstuff/$contract/g" multisite.mk > /omd/sites/$site/etc/check_mk/multisite.mka
sed -i "s/tsstuff/$contract/g" notifications.mk
sed -i "s/TSSTUFF/${contract^^}/g" notifications.mk
sed "s/tsstuff/$contract/g" notifications.mk > /omd/sites/$site/etc/check_mk/conf.d/wato/notifications.mk
sed "s/tsstuff/$contract/g" rules.mk > /omd/sites/$site/etc/check_mk/conf.d/wato/rules.mk
sed "s/tsstuff/$contract/g" users.mk > /omd/sites/$site/etc/check_mk/multisite.d/wato/users.mk
cp timeperiods.mk /omd/sites/$site/etc/check_mk/conf.d/wato/timeperiods.mk
cmk -II; cmk -O
htpasswd -b /omd/sites/$site/etc/htpasswd  $adminname $password
htpasswd -b /omd/sites/$site/etc/htpasswd  omdadmin $password

