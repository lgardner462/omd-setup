# Written by Multisite UserDB
# encoding: utf-8

multisite_users = \
{'machineuser': {'alias': u'machine',
                 'automation_secret': 'YDHDGDAPHVFUYHXLPFXN',
                 'force_authuser': False,
                 'force_authuser_webservice': False,
                 'locked': False,
                 'roles': ['admin'],
                 'start_url': 'dashboard.py'},
 'tsstuff-admin': {'alias': u'tsstuff-admin',
                 'force_authuser': False,
                 'force_authuser_webservice': False,
                 'locked': False,
                 'roles': ['admin'],
                 'start_url': 'dashboard.py'},
 'tsstuff-pager': {'alias': u'tsstuff-admin', 'locked': True, 'roles': ['user']},
 'tsstuff-view': {'alias': u'tsstuff view',
                'force_authuser': False,
                'force_authuser_webservice': False,
                'locked': False,
                'roles': ['guest'],
                'start_url': 'dashboard.py'},
 'omdadmin': {'alias': u'omdadmin',
              'force_authuser': False,
              'force_authuser_webservice': False,
              'locked': True,
              'roles': ['admin'],
              'start_url': 'dashboard.py'}}

