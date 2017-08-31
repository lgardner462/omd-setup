# Written by WATO
# encoding: utf-8


extra_service_conf.setdefault('_ec_sl', [])

extra_service_conf['_ec_sl'] = [
  ( 10, ['tsstuff-basic', ], ALL_HOSTS, ALL_SERVICES ),
  ( 20, ['tsstuff-critical', ], ALL_HOSTS, ALL_SERVICES ),
  ( 30, ['tsstuff-critical-24x7', ], ALL_HOSTS, ALL_SERVICES ),
  ( 10, [], ALL_HOSTS, ['Check_MK$'] ),
] + extra_service_conf['_ec_sl']

checkgroup_parameters.setdefault('filesystem', [])

checkgroup_parameters['filesystem'] = [
  ( {'levels': [(1, (-10.0, -5.0)), (1099511627776, (-5.0, -1.0)), (5497558138880, (-2.0, -1.0))]}, [], ALL_HOSTS, ALL_SERVICES ),
] + checkgroup_parameters['filesystem']



active_checks.setdefault('icmp', [])

active_checks['icmp'] = [
  ( {}, [], ALL_HOSTS ),
] + active_checks['icmp']


extra_host_conf.setdefault('check_interval', [])

extra_host_conf['check_interval'] = [
  ( 5, ['tsstuff-basic', ], ALL_HOSTS ),
  ( 5, ['tsstuff-critical', ], ALL_HOSTS ),
  ( 5, ['tsstuff-critical-24x7', ], ALL_HOSTS ),
] + extra_host_conf['check_interval']


host_contactgroups = [
  ( 'tsstuff-admins', ['tsstuff-basic', ], ALL_HOSTS ),
  ( 'tsstuff-admins', ['tsstuff-critical', ], ALL_HOSTS ),
  ( 'tsstuff-admins', ['tsstuff-critical-24x7', ], ALL_HOSTS ),
  ( 'tsstuff-pager', ['tsstuff-critical', ], ALL_HOSTS ),
  ( 'tsstuff-pager', ['tsstuff-critical-24x7', ], ALL_HOSTS ),
] + host_contactgroups


extra_service_conf.setdefault('check_interval', [])

extra_service_conf['check_interval'] = [
  ( 1440, [], ALL_HOSTS, ['Check_MK HW/SW Inventory$'], {'comment': u'Restrict HW/SW-Inventory to once a day'} ),
  ( 5, ['tsstuff-basic', ], ALL_HOSTS, ALL_SERVICES ),
  ( 5, ['tsstuff-critical', ], ALL_HOSTS, ALL_SERVICES ),
  ( 5, ['tsstuff-critical-24x7', ], ALL_HOSTS, ALL_SERVICES ),
] + extra_service_conf['check_interval']


extra_host_conf.setdefault('notification_interval', [])

extra_host_conf['notification_interval'] = [
  ( 60, ['tsstuff-basic', ], ALL_HOSTS ),
  ( 60, ['tsstuff-critical', ], ALL_HOSTS ),
  ( 60, ['tsstuff-critical-24x7', ], ALL_HOSTS ),
] + extra_host_conf['notification_interval']


static_checks.setdefault('cpu_load', [])

static_checks['cpu_load'] = [
  ( ('hpux_cpu', None, (0.01, 0.02)), ['cmk-agent', 'critical', ], ALL_HOSTS ),
] + static_checks['cpu_load']


extra_host_conf.setdefault('max_check_attempts', [])

extra_host_conf['max_check_attempts'] = [
  ( 3, [], ALL_HOSTS ),
] + extra_host_conf['max_check_attempts']


extra_service_conf.setdefault('notification_period', [])

extra_service_conf['notification_period'] = [
  ( 'allday', ['tsstuff-basic', ], ALL_HOSTS, ALL_SERVICES ),
  ( 'allday', ['tsstuff-critical', ], ALL_HOSTS, ALL_SERVICES ),
  ( 'allday', [], ['tsstuff-critical-24x7'], ALL_SERVICES ),
] + extra_service_conf['notification_period']


checkgroup_parameters.setdefault('filesystem', [])

#checkgroup_parameters['filesystem'] = [
#  ( {'levels': (75.0, 95.0)}, [], ALL_HOSTS, [u'/pool002'] ),
#  ( {'levels': (95.0, 96.0)}, [], ALL_HOSTS, ALL_SERVICES ),
#] + checkgroup_parameters['filesystem']


active_checks.setdefault('ssh', [])

active_checks['ssh'] = [
  ( {'timeout': 120}, [], ALL_HOSTS ),
] + active_checks['ssh']


extra_service_conf.setdefault('notification_interval', [])

extra_service_conf['notification_interval'] = [
  ( 60, ['tsstuff-basic', ], ALL_HOSTS, ALL_SERVICES ),
  ( 60, ['tsstuff-critical', ], ALL_HOSTS, ALL_SERVICES ),
  ( 60, ['tsstuff-critical-24x7', ], ALL_HOSTS, ALL_SERVICES ),
] + extra_service_conf['notification_interval']


ping_levels = [
  ( {'loss': (80.0, 100.0), 'packets': 6, 'timeout': 20, 'rta': (1500.0, 3000.0)}, ['wan', ], ALL_HOSTS, {'comment': u'Allow longer round trip times when pinging WAN hosts'} ),
] + ping_levels


extra_service_conf.setdefault('retry_interval', [])

extra_service_conf['retry_interval'] = [
  ( 3, [], ALL_HOSTS, ALL_SERVICES ),
] + extra_service_conf['retry_interval']


service_contactgroups = [
  ( 'tsstuff-admins', ['tsstuff-basic', ], ALL_HOSTS, ALL_SERVICES ),
  ( 'tsstuff-admins', ['tsstuff-critical', ], ALL_HOSTS, ALL_SERVICES ),
  ( 'tsstuff-admins', ['tsstuff-critical-24x7', ], ALL_HOSTS, ALL_SERVICES ),
  ( 'tsstuff-pager', ['tsstuff-critical', ], ALL_HOSTS, ALL_SERVICES ),
  ( 'tsstuff-pager', ['tsstuff-critical-24x7', ], ALL_HOSTS, ALL_SERVICES ),
] + service_contactgroups


service_groups = [
  ( 'tsstuff-critical-24x7', ['tsstuff-critical-24x7', ], ALL_HOSTS, ALL_SERVICES ),
  ( 'tsstuff-basic', ['tsstuff-basic', ], ALL_HOSTS, ALL_SERVICES ),
  ( 'tsstuff-critical', ['tsstuff-critical', ], ALL_HOSTS, ALL_SERVICES ),
] + service_groups


bulkwalk_hosts = [
  ( ['snmp', '!snmp-v1', ], ALL_HOSTS, {'comment': u'Hosts with the tag "snmp-v1" must not use bulkwalk'} ),
] + bulkwalk_hosts


extra_service_conf.setdefault('max_check_attempts', [])

extra_service_conf['max_check_attempts'] = [
  ( 3, [], ALL_HOSTS, ALL_SERVICES ),
] + extra_service_conf['max_check_attempts']


if only_hosts == None:
    only_hosts = []

only_hosts = [
  ( ['!offline', ], ALL_HOSTS, {'comment': u'Do not monitor hosts with the tag "offline"'} ),
] + only_hosts


host_groups = [
  ( 'tsstuff-basic', ['tsstuff-basic', ], ALL_HOSTS ),
  ( 'tsstuff-critical', ['tsstuff-critical', ], ALL_HOSTS ),
  ( 'tsstuff-critical-24x7', ['tsstuff-critical-24x7', ], ALL_HOSTS ),
] + host_groups


extra_host_conf.setdefault('notification_period', [])

extra_host_conf['notification_period'] = [
  ( 'allday', ['tsstuff-basic', ], ALL_HOSTS ),
  ( 'allday', ['tsstuff-critical', ], ALL_HOSTS ),
  ( 'allday', ['tsstuff-critical-24x7', ], ALL_HOSTS ),
] + extra_host_conf['notification_period']


extra_host_conf.setdefault('retry_interval', [])

extra_host_conf['retry_interval'] = [
  ( 4.0, [], ALL_HOSTS ),
] + extra_host_conf['retry_interval']

