{% from slspath + "/map.jinja" import flume with context %}

{{ sls }}~properties_file:
  file.managed:
    - name: {{ flume.dirs.conf }}/flume-conf.properties
    - source: salt://{{ slspath }}/templates/flume-conf.properties.jinja
    - template: jinja
    - mode: 0644
    - context:
        agents: {{ flume.agents }}
    - require:
      - file: {{ slspath }}.install~link_current_path
      - file: {{ slspath }}.install~create_dirs

{{ sls }}~env_file:
  file.managed:
    - name: {{ flume.dirs.conf }}/flume-env.sh
    - source: salt://{{ slspath }}/templates/flume-env.sh.jinja
    - template: jinja
    - mode: 0644
    - context:
        env: {{ flume.env }}
    - watch_in:
      - service: {{ slspath }}.service~flume
    - require:
      - file: {{ sls }}~properties_file

{{ sls }}~log4j:
  file.managed:
    - name: {{ flume.dirs.conf }}/log4j.properties
    - source: salt://{{ slspath }}/templates/log4j.properties.jinja
    - template: jinja
    - mode: 0644
    - context:
        cfg: {{ flume }}
    - watch_in:
      - service: {{ slspath }}.service~flume
    - require:
      - file: {{ sls }}~properties_file
