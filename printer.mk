host_groups = [
  ( 'tsstuff-printer', ['tsstuff-printer'], ALL_HOSTS ),   
  ( 'snmp', ['snmp'], ALL_HOSTS ), 
] + host_groups


extra_service_conf.setdefault('_ec_sl', [])

extra_service_conf['_ec_sl'] = [
  ( 0, ['tsstuff-printer'] , ALL_HOSTS, ALL_SERVICES),
] + extra_service_conf['_ec_sl']


extra_host_conf.setdefault('check_interval', [])

extra_host_conf['check_interval'] = [
  ( 5, ['tsstuff-printer', ], ALL_HOSTS ),
] + extra_host_conf['check_interval']


host_contactgroups = [
  ( 'tsstuff-admins', ['tsstuff-printer'], ALL_HOSTS),
] + host_contactgroups


extra_service_conf.setdefault('check_interval', [])

extra_service_conf['check_interval'] = [
  ( 5, ['tsstuff-printer', ], ALL_HOSTS, ALL_SERVICES ),
] + extra_service_conf['check_interval']


extra_host_conf.setdefault('notification_interval', [])

extra_host_conf['notification_interval'] = [
  ( 60, ['tsstuff-printer', ], ALL_HOSTS ),
] + extra_host_conf['notification_interval']


extra_service_conf.setdefault('notification_period', [])

extra_service_conf['notification_period'] = [
  ( 'allday', ['tsstuff-printer', ], ALL_HOSTS, ALL_SERVICES ),
] + extra_service_conf['notification_period']


extra_service_conf.setdefault('notification_interval', [])

extra_service_conf['notification_interval'] = [
  ( 60, ['tsstuff-printer', ], ALL_HOSTS, ALL_SERVICES ),
] + extra_service_conf['notification_interval']


service_contactgroups = [
  ( 'tsstuff-admins', ['tsstuff-printer', ], ALL_HOSTS, ALL_SERVICES ),
] + service_contactgroups


service_groups = [
  ( 'tsstuff-printer', ['tsstuff-printer', ], ALL_HOSTS, ALL_SERVICES ),
] + service_groups


host_groups = [
  ( 'tsstuff-printer', ['tsstuff-printer', ], ALL_HOSTS ),
] + host_groups


extra_host_conf.setdefault('notification_period', [])

extra_host_conf['notification_period'] = [
  ( 'allday', ['tsstuff-printer', ], ALL_HOSTS ),
] + extra_host_conf['notification_period']







#######################################################
########### Printer notifications start here ###########
#######################################################


notification_rules += [{'allow_disable': True,
  'comment': u'printer host first two emails (ack) \n',
  'contact_all': False,
  'contact_all_with_email': False,
  'contact_groups': ['tsstuff-admins'],
  'contact_object': False,
  'description': u'print host first 2 emails, one per hour (ack)',
  'disabled': False,
  'match_escalation': (1, 2),
  'match_host_event': ['x'],
  'match_hostgroups': ['tsstuff-printer'],
  'notify_plugin': ('asciimail',
                    {'common_body': u'Host:     $HOSTNAME$\n',
                     'from': 'tsstuff-noc@techsquare.com',
                     'host_body': u'Event:    $EVENT_TXT$\nOutput:   $HOSTOUTPUT$\nPerfdata: $HOSTPERFDATA$\n$LONGHOSTOUTPUT$\n',
                     'host_subject': u'tsstuff ACK alert: $HOSTNAME$ - $EVENT_TXT$',
                     'reply_to': 'tsstuff-noc@techsquare.com',
                     'service_body': u'Service:  $SERVICEDESC$\nEvent:    $EVENT_TXT$\nOutput:   $SERVICEOUTPUT$\nPerfdata: $SERVICEPERFDATA$\n$LONGSERVICEOUTPUT$\n'})},
 {'allow_disable': True,
  'comment': u'printer host first two emails (sched downtime) \n',
  'contact_all': False,
  'contact_all_with_email': False,
  'contact_groups': ['tsstuff-admins'],
  'contact_object': False,
  'description': u'printer host first 2 emails, one per hour (sched)',
  'disabled': False,
  'match_escalation': (1, 2),
  'match_host_event': ['s'],
  'match_hostgroups': ['tsstuff-printer'],
  'notify_plugin': ('asciimail',
                    {'common_body': u'Host:     $HOSTNAME$\n',
                     'from': 'tsstuff-noc@techsquare.com',
                     'host_body': u'Event:    $EVENT_TXT$\nOutput:   $HOSTOUTPUT$\nPerfdata: $HOSTPERFDATA$\n$LONGHOSTOUTPUT$\n',
                     'host_subject': u'tsstuff scheduled downtime: $HOSTNAME$ - $EVENT_TXT$',
                     'reply_to': 'tsstuff-noc@techsquare.com',
                     'service_body': u'Service:  $SERVICEDESC$\nEvent:    $EVENT_TXT$\nOutput:   $SERVICEOUTPUT$\nPerfdata: $SERVICEPERFDATA$\n$LONGSERVICEOUTPUT$\n'})},
 {'allow_disable': True,
  'comment': u'printer host first two emails (flapping) \n',
  'contact_all': False,
  'contact_all_with_email': False,
  'contact_groups': ['tsstuff-admins'],
  'contact_object': False,
  'description': u'printer host first 2 emails, one per hour (flap)',
  'disabled': False,
  'match_escalation': (1, 2),
  'match_host_event': ['f'],
  'match_hostgroups': ['tsstuff-printer'],
  'notify_plugin': ('asciimail',
                    {'common_body': u'Host:     $HOSTNAME$\n',
                     'from': 'tsstuff-noc@techsquare.com',
                     'host_body': u'Event:    $EVENT_TXT$\nOutput:   $HOSTOUTPUT$\nPerfdata: $HOSTPERFDATA$\n$LONGHOSTOUTPUT$\n',
                     'host_subject': u'tsstuff FLAPPING alert: $HOSTNAME$ - $EVENT_TXT$',
                     'reply_to': 'tsstuff-noc@techsquare.com',
                     'service_body': u'Service:  $SERVICEDESC$\nEvent:    $EVENT_TXT$\nOutput:   $SERVICEOUTPUT$\nPerfdata: $SERVICEPERFDATA$\n$LONGSERVICEOUTPUT$\n'})},
 {'allow_disable': True,
  'comment': u'printer host first two emails (recovery) \n',
  'contact_all': False,
  'contact_all_with_email': False,
  'contact_groups': ['tsstuff-admins'],
  'contact_object': False,
  'description': u'printer host first 2 emails, one per hour (recov)',
  'disabled': False,
  'match_escalation': (1, 2),
  'match_host_event': ['dr', 'ur'],
  'match_hostgroups': ['tsstuff-printer'],
  'notify_plugin': ('asciimail',
                    {'common_body': u'Host:     $HOSTNAME$\n',
                     'from': 'tsstuff-noc@techsquare.com',
                     'host_body': u'Event:    $EVENT_TXT$\nOutput:   $HOSTOUTPUT$\nPerfdata: $HOSTPERFDATA$\n$LONGHOSTOUTPUT$\n',
                     'host_subject': u'tsstuff RECOVERY alert: $HOSTNAME$ - $EVENT_TXT$',
                     'reply_to': 'tsstuff-noc@techsquare.com',
                     'service_body': u'Service:  $SERVICEDESC$\nEvent:    $EVENT_TXT$\nOutput:   $SERVICEOUTPUT$\nPerfdata: $SERVICEPERFDATA$\n$LONGSERVICEOUTPUT$\n'})},
 {'allow_disable': True,
  'comment': u'printer host first two emails (problem) \n',
  'contact_all': False,
  'contact_all_with_email': False,
  'contact_groups': ['tsstuff-admins'],
  'contact_object': False,
  'description': u'printer host first 2 emails, one per hour (problem)',
  'disabled': False,
  'match_escalation': (1, 2),
  'match_host_event': ['rd', 'ru', 'du', 'ud'],
  'match_hostgroups': ['tsstuff-printer'],
  'notify_plugin': ('asciimail',
                    {'common_body': u'Host:     $HOSTNAME$\n',
                     'from': 'tsstuff-noc@techsquare.com',
                     'host_body': u'Event:    $EVENT_TXT$\nOutput:   $HOSTOUTPUT$\nPerfdata: $HOSTPERFDATA$\n$LONGHOSTOUTPUT$\n',
                     'host_subject': u'tsstuff PROBLEM alert: $HOSTNAME$ - $EVENT_TXT$',
                     'reply_to': 'tsstuff-noc@techsquare.com',
                     'service_body': u'Service:  $SERVICEDESC$\nEvent:    $EVENT_TXT$\nOutput:   $SERVICEOUTPUT$\nPerfdata: $SERVICEPERFDATA$\n$LONGSERVICEOUTPUT$\n'})},
 {'allow_disable': True,
  'comment': u'printer host escalation emails,send daily (ack)\n',
  'contact_all': False,
  'contact_all_with_email': False,
  'contact_groups': ['tsstuff-admins'],
  'contact_object': False,
  'description': u'host printer escalation emails, send daily  (ack)',
  'disabled': False,
  'match_escalation': (3, 999999),
  'match_host_event': ['x'],
  'match_hostgroups': ['tsstuff-printer'],
  'notify_plugin': ('asciimail',
                    {'common_body': u'Host:     $HOSTNAME$\n',
                     'from': 'tsstuff-noc@techsquare.com',
                     'host_body': u'Event:    $EVENT_TXT$\nOutput:   $HOSTOUTPUT$\nPerfdata: $HOSTPERFDATA$\n$LONGHOSTOUTPUT$\n\n',
                     'host_subject': u'tsstuff ACK alert:$HOSTNAME$ - $EVENT_TXT$',
                     'reply_to': 'tsstuff-noc@techsquare.com',
                     'service_body': u'Service:  $SERVICEDESC$\nEvent:    $EVENT_TXT$\nOutput:   $SERVICEOUTPUT$\nPerfdata: $SERVICEPERFDATA$\n$LONGSERVICEOUTPUT$\n'})},
 {'allow_disable': True,
  'comment': u'printer host escalation emails,send daily (sched downtime)\n',
  'contact_all': False,
  'contact_all_with_email': False,
  'contact_groups': ['tsstuff-admins'],
  'contact_object': False,
  'description': u'host printer escalation emails, send daily (sched)',
  'disabled': False,
  'match_escalation': (3, 999999),
  'match_host_event': ['s'],
  'match_hostgroups': ['tsstuff-printer'],
  'notify_plugin': ('asciimail',
                    {'common_body': u'Host:     $HOSTNAME$\n',
                     'from': 'tsstuff-noc@techsquare.com',
                     'host_body': u'Event:    $EVENT_TXT$\nOutput:   $HOSTOUTPUT$\nPerfdata: $HOSTPERFDATA$\n$LONGHOSTOUTPUT$\n\n',
                     'host_subject': u'tsstuff scheduled downtime:$HOSTNAME$ - $EVENT_TXT$',
                     'reply_to': 'tsstuff-noc@techsquare.com',
                     'service_body': u'Service:  $SERVICEDESC$\nEvent:    $EVENT_TXT$\nOutput:   $SERVICEOUTPUT$\nPerfdata: $SERVICEPERFDATA$\n$LONGSERVICEOUTPUT$\n'})},
 {'allow_disable': True,
  'comment': u'printer host escalation emails,send daily (flap) \n',
  'contact_all': False,
  'contact_all_with_email': False,
  'contact_groups': ['tsstuff-admins'],
  'contact_object': False,
  'description': u'host printer escalation emails, send daily  (flap)',
  'disabled': False,
  'match_escalation': (3, 999999),
  'match_host_event': ['f'],
  'match_hostgroups': ['tsstuff-printer'],
  'notify_plugin': ('asciimail',
                    {'common_body': u'Host:     $HOSTNAME$\n',
                     'from': 'tsstuff-noc@techsquare.com',
                     'host_body': u'Event:    $EVENT_TXT$\nOutput:   $HOSTOUTPUT$\nPerfdata: $HOSTPERFDATA$\n$LONGHOSTOUTPUT$\n\n',
                     'host_subject': u'tsstuff FLAPPING alert:$HOSTNAME$ - $EVENT_TXT$',
                     'reply_to': 'tsstuff-noc@techsquare.com',
                     'service_body': u'Service:  $SERVICEDESC$\nEvent:    $EVENT_TXT$\nOutput:   $SERVICEOUTPUT$\nPerfdata: $SERVICEPERFDATA$\n$LONGSERVICEOUTPUT$\n'})},
 {'allow_disable': True,
  'comment': u'printer host escalation emails,send daily (problem)\n',
  'contact_all': False,
  'contact_all_with_email': False,
  'contact_groups': ['tsstuff-admins'],
  'contact_object': False,
  'description': u'host printer escalation emails, send daily (prob)',
  'disabled': False,
  'match_escalation': (3, 999999),
  'match_host_event': ['rd', 'ru', 'du', 'ud'],
  'match_hostgroups': ['tsstuff-printer'],
  'notify_plugin': ('asciimail',
                    {'common_body': u'Host:     $HOSTNAME$\n',
                     'from': 'tsstuff-noc@techsquare.com',
                     'host_body': u'Event:    $EVENT_TXT$\nOutput:   $HOSTOUTPUT$\nPerfdata: $HOSTPERFDATA$\n$LONGHOSTOUTPUT$\n\n',
                     'host_subject': u'tsstuff PROBLEM alert:$HOSTNAME$ - $EVENT_TXT$',
                     'reply_to': 'tsstuff-noc@techsquare.com',
                     'service_body': u'Service:  $SERVICEDESC$\nEvent:    $EVENT_TXT$\nOutput:   $SERVICEOUTPUT$\nPerfdata: $SERVICEPERFDATA$\n$LONGSERVICEOUTPUT$\n'})},
 {'allow_disable': True,
  'comment': u'printer host escalation emails,send daily (recovery) \n',
  'contact_all': False,
  'contact_all_with_email': False,
  'contact_groups': ['tsstuff-admins'],
  'contact_object': False,
  'description': u'host printer escalation emails, send daily  (recovery)',
  'disabled': False,
  'match_escalation': (3, 999999),
  'match_host_event': ['dr', 'ur'],
  'match_hostgroups': ['tsstuff-printer'],
  'notify_plugin': ('asciimail',
                    {'common_body': u'Host:     $HOSTNAME$\n',
                     'from': 'tsstuff-noc@techsquare.com',
                     'host_body': u'Event:    $EVENT_TXT$\nOutput:   $HOSTOUTPUT$\nPerfdata: $HOSTPERFDATA$\n$LONGHOSTOUTPUT$\n\n',
                     'host_subject': u'tsstuff RECOVERY alert:$HOSTNAME$ - $EVENT_TXT$',
                     'reply_to': 'tsstuff-noc@techsquare.com',
                     'service_body': u'Service:  $SERVICEDESC$\nEvent:    $EVENT_TXT$\nOutput:   $SERVICEOUTPUT$\nPerfdata: $SERVICEPERFDATA$\n$LONGSERVICEOUTPUT$\n'})},

]
