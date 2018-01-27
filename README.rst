============
Apache Flume
============
Install and configure `Apache Flume <https://flume.apache.org/>`_ a distributed, reliable,
and available service for efficiently collecting, aggregating, and moving large amounts of log data.

.. Note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``flume``
---------

Download, install, configure Apache Flume.

Configuration
=============

Main important sections are ``agents`` and ``plugins``.

Agents
------
One or more agents could be added under ``agents`` section.
And each agent could have many sources, channels, sinks.

.. code:: yaml

    flume:

      agents:

        agent01:

          sources:
            httpSource:
              type: http
              port: 8080

          channels:
            httpChannel01:
              type: memory
              capacity: 1000000
              transactionCapacity: 100000
            nullChannel01:
              type: memory
              capacity: 1000
              transactionCapacity: 1000

          sinks:
            httpFileSink01:
              type: file_roll
              channel: httpChannel01
              sink:
                directory: /var/log/flume
                rollInterval: 300
            nullSink01:
              type: 'null'
              channel: nullChannel01

          sinkgroups:
            sinkgroup01:
              processor:
                type: failover
                backoff: 'false'
                selector: failover

Plugins
-------
More Flume plugins (i.e. external libs) could be added under ``plugins`` section.

If the plugin doesn't follow `Flume convention
<https://flume.apache.org/FlumeUserGuide.html#directory-layout-for-plugins>`_,
then the non-standard dirs should be exposed in ``classpath`` section.

If the plugin does follow the convention, then no need to ``classpath`` section.

.. code:: yaml

    flume:

      plugins:

        hadoop:
          source: https://archive.apache.org/dist/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
          hash: False
          paths:
            # No need to expose dirs here.
            native:
              src: lib/native
              dest: native
            hdfs:
              src: share/hadoop/hdfs
              dest: hdfs
              # Expose classpath dirs,
              # in case the plugin doesn't follow Flume plugins convention.
              classpath:
                - '*'
                - 'lib/*'
            common:
              src: share/hadoop/common
              dest: common
              classpath:
                - '*'
                - 'lib/*'

.. vim: fenc=utf-8 spell spl=en cc=100 tw=99 fo=want sts=4 sw=4 et

