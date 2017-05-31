{% if not salt['file.file_exists']('/etc/check-mk-agent/mrpe.cfg') %}
/etc/check-mk-agent/mrpe.cfg:
  file:
   - managed
   - user: 0
   - group: 0 
   - mode: 644 
{% endif %}
append_mrpe.cfg:
  file:
     - append
     - name: /etc/check-mk-agent/mrpe.cfg
     - text: "USERCPU /usr/lib64/nagios/plugins/check_usercpu -w 90 -c 9999999"

/usr/lib64/nagios/plugins/contrib:
  file.directory:
    - user: 0
    - group: 0
    - mode: 755 
    - makedirs: True

/usr/lib64/nagios/plugins/contrib/check_usercpu:
  file:
    - managed
    - user: 0
    - group: 0
    - mode: 755 
    - source: salt://usr/lib/nagios/plugins/contrib/check_usercpu    
