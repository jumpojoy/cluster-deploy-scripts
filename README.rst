======================
Cluster Deploy Scritps
======================

Repository contains various scripts to deploy MCP cluster.

Installation
============

To install heat client, it's recommended to setup Python virtualenv and
install tested versions of openstack clients that are defined in
`requirements.txt` file.

Install build tools (eg. on Ubuntu):
  .. code-block:: bash

     apt-get install python-dev python-pip python-virtualenv build-essential libffi-dev libssl-dev

Create and activate virtualenv named `venv-heat`:
  .. code-block:: bash

     virtualenv venv-heat
     source ./venv-heat/bin/activate

Install requirements:
  .. code-block:: bash

     pip install -r requirements.txt

Usage
=====

- setup environment file, eg. ``env/salt_single_public.env``, look at example
  file first
- source credentials and required environment variables. You can download
  openrc file from Horizon dashboard.

  .. code-block:: bash

     source my_tenant-openrc.sh

- deploy stack

  .. code-block:: bash

     ./create_stack.sh salt_single_public

Stacks
======

.. list-table::
   :stub-columns: 1

   *  - salt_single_public
      - Base stack which deploys network and single-node Salt master
   *  - openstack_cluster_public
      - Deploy OpenStack cluster with OpenContrail, requires
        ``salt_single_public``
   *  - openvstorage_cluster_private
      - Deploy Open vStorage infrastructure on top of
        ``openstack_cluster_public``
   *  - lbaas_contrail_f5_test
      - Test stack to prove functionality of Contrail F5 integration
   *  - k8s_single_opencontrail_
      - Kubernetes with OpenContrail

.. _k8s_single_opencontrail: https://github.com/tcpcloud/heat-templates/tree/master/doc/k8s_single_opencontrail.rst
