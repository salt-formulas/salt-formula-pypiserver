
==================================
pypiserver
==================================

Service pypiserver description

Sample pillars
==============

Single pypiserver service

.. code-block:: yaml

    pypiserver:
      server:
        enabled: true
        version: icehouse

    supervisor:
      server:
        service:
          pypiserver:
            name: pypiserver
            type: pypiserver

Read more
=========

* links
