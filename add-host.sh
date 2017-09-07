#!/bin/bash
pingonly=0
printer=0
noreloading=0
#contract=$(whoami)
show_help () {
    echo '-p ping only host (you still need to type a criticality flag)'
    echo '-b for basic host <hostname>'
    echo '-c for critical host <hostname>'
    echo '-x for critical 24x7 host <hostname>'
    echo '-n to not reload after adding host'
    echo '-r for printer (doesn't need criticality flag)'
    echo 'adduser.sh -b testhost -w neuro -s nodes' 
    exit
}

if [[ $EUID -ne 0 ]];then
        site=$(whoami)
else
        echo "Script must be run as OMD user"
        exit 1
fi


while getopts "hb:c:x::pw:rn" o;do
	case "$o" in
		h)
			show_help
			exit 0
			;;
		b)
			type=basic
			hostgroupdir=basic
			host=$OPTARG
			;;
		c)
			type=critical
                        hostgroupdir=critical
			host=$OPTARG
			;;
		x)
			type=critical-24x7
                        hostgroupdir=critical24x7
			host=$OPTARG
			;;
		p)
			pingonly=1
			;;
		n)
			noreloading=1
			;;
                r)
                        printer=1
			type=printer
			hostgroupdir=printer
			host=$OPTARG
                        ;;
	esac
done	
shift $(( $OPTIND -1))
hosttag=$contract-$type
if [ -z $type ];then
        echo You must specify a host type
        show_help
	exit 0
elif [ -z $site ];then
        echo you must specify a site
        show_help
        exit 0
elif [ -z $contract ]; then 
        echo you must specify a contract
        show_help 
        exit 0
fi
topdir=/omd/sites/$site/etc/check_mk/conf.d/wato
if [ ! -d $topdir/basic ];then
        mkdir $topdir/basic
fi
if [ ! -d $topdir/critical ];then
        mkdir $topdir/critical
fi
if [ ! -d $topdir/critical24x7 ];then
        mkdir $topdir/critical24x7
fi
#if [ ! -d $topdir/printer ];then
#        mkdir $topdir/printer
#fi
	
fulldir=$topdir"/"$hostgroupdir"/"$host

if [ -d $fulldir ];then
        echo A host by that name with the selected priority already exists.
        exit 1
fi
mkdir $fulldir
if [ $pingonly -eq 1 ];then
        echo -e  'all_hosts += [ 
"'$host'|lan|lnx|ping-only|tcp|'$hosttag'|wato|/" + FOLDER_PATH + "/"
]' > $fulldir"/"hosts.mk

elif [ $printer -eq 1 ];then

        if [ ! -d $topdir/printer ];then
                mkdir $topdir/printer
        fi
        echo -e 'all_hosts += [
"'$host'|lan|lnx|snmp|'$hosttag'|wato|/" + FOLDER_PATH + "/"
]' > $fulldir"/"hosts.mk


else

        echo -e  'all_hosts += [ 
"'$host'|lan|lnx|cmk-agent|tcp|'$hosttag'|wato|/" + FOLDER_PATH + "/"
]' > $fulldir"/"hosts.mk


fi

if [ $noreloading -eq 0 ];then
        cmk -II $host
        cmk -O
fi




