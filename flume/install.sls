{% from slspath + "/map.jinja" import flume with context %}

{{ sls }}~create_user:
  user.present:
    - name: {{ flume.user }}
    - fullname: Flume User
    - shell: /bin/bash
    - empty_password: True

{{ sls }}~create_dirs:
  file.directory:
    - names:
      - {{ flume.dirs.prefix }}
      - {{ flume.dirs.conf }}
      - {{ flume.dirs.log }}
    - user: {{ flume.user }}
    - group: {{ flume.group }}

{{ sls }}~download_and_extract:
  archive.extracted:
    - name: {{ flume.dirs.install }}
    - source: {{ flume.download.source }}
    - source_hash: {{ flume.download.hash.value }}
    - options: --strip-components=1
    - enforce_toplevel: False
    - user: {{ flume.user }}
    - group: {{ flume.group }}
    - if_missing: {{ flume.dirs.install }}
    - require:
      - file: {{ sls }}~create_dirs

{{ sls }}~link_current_path:
  file.symlink:
    - name: {{ flume.dirs.prefix }}/current
    - target: {{ flume.dirs.install }}
    - user: {{ flume.user }}
    - group: {{ flume.group }}
    - require:
      - archive: {{ sls }}~download_and_extract
