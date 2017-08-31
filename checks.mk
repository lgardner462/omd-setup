checks = [
( ALL_HOSTS, "cpu.threads" , None, (5000,7000) ),
]

tcp_connect_timeout = 120.0

ignored_services += [
( ALL_HOSTS, ['Postfix Queue' ]),
( ["ping-only"], ALL_HOSTS, "Number of Threads" ),
( ["ping-only"], ALL_HOSTS, "Check_MK"),
]

tcp_connect_timeout = 120.0

inventory_df_exclude_fs += [

'autofs',
'binfmt_misc',
'cgroup',
'cifs',
'configfs',
'debugfs',
'devpts',
'devtmpfs',
'fuse.gvfsd-fuse',
'fuse.sshfs',
'fusectl',
'hugetlbfs',
'iso9660',
'mqueue',
'nfs',
'nfsd',
'proc',
'pstore',
'rpc_pipefs',
'securityfs',
'smbfs',
'sysfs',
'tmpfs',

]

ignored_checktypes = [ "nfsmounts", "NFS mount", ]



# List of mountpoints to skipt at inventory
# inventory_df_exclude_mountpoints += [ '/dev', '/pts', '/sys' ]




