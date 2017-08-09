#!/bin/bash
 
CREDENTIALS_DIR=/home/lgardner/bin/
#Can probably hardcode some url values per contract in here to pass a single flag for a contract that gives default value for url/site/contract name

#Has to run as a machineuser with secret, can use cat $(/omd/sites/$site/var/check_mk/web/$machineusername/automation.secret if running locally, otherwise must hardcode user/secret

show_help () {
    echo "Remote ack an omd host or service via curl"
    echo "-c is the contract neuro,c3ddb,engaging"
    echo "-n is the node/host name for the ack    _required_"
    echo "-s is the service name if you are acking a service   _optional_"
    exit
}

urlencode() {
  python -c 'import urllib, sys; print urllib.quote(sys.argv[1], sys.argv[2])' \
    "$1" "$urlencode_safe"
}


while getopts "h?n:s:o:u:c:a:p:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    c)
	contract=$OPTARG
	;;
    n)
	node=$OPTARG
        ;;
    s)
	service=$OPTARG
	service=$( urlencode "$service")
	;;
    esac
done

if [[ $contract == openmind ]];then
	contract="neuro"
fi

source $CREDENTIALS_DIR/$contract

#machine secret, needed to ack remotely, also prevents machine user from being in htpasswd and being able to login
ms="YDHDGDAPHVFUYHXLPFXN"
#ms=$(cat /omd/sites/$site/var/check_mk/web/machineuser/automation.secret)


if [ -z ${service} ];then

curl -u $adminname:$adminpw 'http://'"$url"'/'"$site"'/check_mk/view.py?&_do_confirm=Yes!&filled_in=actions&_transid=-1&_do_actions=yes&actions=yes&host='"$node"'&site=&view_name=hoststatus&_acknowledge=Acknowledge&_ack_sticky=on&_ack_notify=on&_ack_expire_days=0&_ack_expire_hours=0&_ack_expire_minutes=0&_ack_comment='"$comment"'&_down_comment=&_down_minutes=60&_down_from_date=2017-04-14&_down_from_time=17%3A20&_down_to_date=2017-04-14&_down_to_time=19%3A20&_down_duration=02%3A00&_fake_output=&_fake_perfdata=&_resched_spread=0&_cusnot_comment=TEST&_comment=&_username=machineuser&_secret='$ms

elif [ $service ];then

curl -u $adminname:$adminpw 'http://'"$url"'/'"$site"'/check_mk/view.py?_do_confirm=Yes!&filled_in=actions&_transid=-1&_do_actions=yes&actions=yes&host='"$node"'&site=&view_name=service&service='"$service"'&_acknowledge=Acknowledge&_ack_sticky=on&_ack_notify=on&_ack_expire_days=0&_ack_expire_hours=0&_ack_expire_minutes=0&_ack_comment='"$comment"'&_fake_output=&_fake_perfdata=&_resched_spread=0&_cusnot_comment=TEST&_comment=&_username=machineuser&_secret='$ms




fi

echo NAME $adminname
echo pw $adminpw
echo url $url
echo site $site
echo comment $comment
echo node $node
echo service $service
