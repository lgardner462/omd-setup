# Written by WATO
# encoding: utf-8

if type(define_hostgroups) != dict:
    define_hostgroups = {}
define_hostgroups.update({'tsstuff-basic': u'tsstuff-basic',
 'tsstuff-critical': u'tsstuff-critical',
 'tsstuff-critical-24x7': u'tsstuff-critical-24x7',
 'testhostgroup': u'testhostgroup'})

if type(define_servicegroups) != dict:
    define_servicegroups = {}
define_servicegroups.update({'tsstuff-basic': u'tsstuff-basic',
 'tsstuff-critical': u'tsstuff-critical',
 'tsstuff-critical-24x7': u'tsstuff-critical-24x7',
 'public': u'public'})

if type(define_contactgroups) != dict:
    define_contactgroups = {}
define_contactgroups.update({'tsstuff-admins': u'tsstuff-admins',
 'tsstuff-pager': u'tsstuff-pager',
 'tsstuff-ts': u'tsstuffts'})

