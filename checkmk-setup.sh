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
#sed "s/tsstuff/$contract/g" contacts.mk > /omd/sites/$site/etc/check_mk/conf.d/wato/contacts.mk 
#sed "s/tsstuff/$contract/g" checks.mk > /omd/sites/$site/etc/check_mk/conf.d/wato/checks.mk
#sed "s/tsstuff/$contract/g" groups.mk > /omd/sites/$site/etc/check_mk/conf.d/wato/groups.mk
#sed "s/tsstuff/$contract/g" multisite.mk > /omd/sites/$site/etc/check_mk/multisite.mka
#sed -i "s/tsstuff/$contract/g" notifications.mk
#sed -i "s/TSSTUFF/${contract^^}/g" notifications.mk
#sed "s/tsstuff/$contract/g" printers.mk > /omd/sites/$site/etc/check_mk/conf.d/wato/printers.mk
#sed "s/tsstuff/$contract/g" notifications.mk > /omd/sites/$site/etc/check_mk/conf.d/wato/notifications.mk
#sed "s/tsstuff/$contract/g" rules.mk > /omd/sites/$site/etc/check_mk/conf.d/wato/rules.mk
#sed "s/tsstuff/$contract/g" users.mk > /omd/sites/$site/etc/check_mk/multisite.d/wato/users.mk
#cp timeperiods.mk /omd/sites/$site/etc/check_mk/conf.d/wato/timeperiods.mk
cd /omd/sites/$site/etc/check_mk/conf.d/wato
mkdir ~/.ssh
chmod 600 ~/.ssh
cp id_rsa ~/.ssh
chmod 400 ~/.ssh/id_rsa
mkdir clone-tmp
git clone git@github.com:lgardner462/omd-config.git clone-tmp
mv clone-tmp/.git ~/etc/check_mk/conf.d/wato/.git
mv clone-tmp/.gitignore ~/etc/check_mk/conf.d/wato/.gitignore
cp ~/git_pull.sh ~/etc/check_mk/conf.d/wato
cp ~/git_push.sh ~/etc/check_mk/conf.d/wato
rm -rf clone-tmp
cd ~/etc/check_mk/conf.d/wato && ./git_pull.sh 


cmk -II; cmk -O
htpasswd -b /omd/sites/$site/etc/htpasswd  $adminname $password
htpasswd -b /omd/sites/$site/etc/htpasswd  omdadmin $password
echo "4 0 * * * $OMD_ROOT/etc/check_mk/conf.d/git_pull.sh" > ~/etc/cron.d/git_pull


