{% from slspath + "/map.jinja" import flume with context %}

{% for plugin_name, plugin_vars in flume.plugins.items() %}

{{ sls }}~create_plugin_dir_{{ plugin_name }}:
  file.directory:
    - name: {{ flume.dirs.plugins_d }}/{{ plugin_name }}
    - makedirs: True
    - user: {{ flume.user }}
    - group: {{ flume.group }}

{{ sls }}~download_and_extract_plugin_{{ plugin_name }}:
  archive.extracted:
    - name: {{ flume.download.path }}/{{ plugin_name }}
    - source: {{ plugin_vars.source }}
    {% if plugin_vars.get('hash') %}
    - source_hash: {{ plugin_vars.hash }}
    {% else %}
    - skip_verify: True
    {% endif %}
    - options: --strip-components=1
    - enforce_toplevel: False
    - user: {{ flume.user }}
    - group: {{ flume.group }}
    - if_missing: {{ flume.download.path }}/{{ plugin_name }}

{% for path_name, path_conf in plugin_vars.pathes.items() %}
{{ sls }}~copy_plugin_pathes_{{ plugin_name }}_{{ path_name }}:
  file.copy:
    - name: {{ flume.dirs.plugins_d }}/{{ plugin_name }}/{{ path_conf.dest }}
    - source: {{ flume.download.path }}/{{ plugin_name }}/{{ path_conf.src }}
    - user: {{ flume.user }}
    - group: {{ flume.group }}
    - require:
      - file: {{ sls }}~create_plugin_dir_{{ plugin_name }}
      - archive: {{ sls }}~download_and_extract_plugin_{{ plugin_name }}
{% endfor %}

{% endfor %}
