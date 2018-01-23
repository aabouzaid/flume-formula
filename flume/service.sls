{% from slspath + "/map.jinja" import flume with context %}

{{ sls }}~service_file:
  file.managed:
    - name: {{ flume.service.conf.dir }}/{{ flume.service.name }}.{{ flume.service.conf.file_extension }}
    - source: salt://{{ slspath }}/templates/flume-{{ flume.service.provider }}.jinja
    - template: jinja
    - mode: 0644
    - context:
        cfg: {{ flume }}
        service: {{ flume.service }}
    - watch_in:
      - service: {{ sls }}~flume
    - require:
      - file: {{ slspath }}.conf~properties_file

{{ sls }}~flume:
  service.running:
    - name: {{ flume.service.name }}
    - require:
      - file: {{ sls }}~service_file
