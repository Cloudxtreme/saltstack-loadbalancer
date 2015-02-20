=============
LoadBalancer-Formula
=============

Formulas to set up and configure a basic load balancer. Tested on CentOS 6.5.

The formula uses haproxy and keepalived to create a resilient load balancing
solution. Haproxy can load balance connections between various frontend and
backend services. Keepalived is used to bind a virtual IP address to a cluster
of servers.

This imitates the functionality of an AWS Elastic Load Balancer (ELB).

.. note::

- See the full Salt Formulas installation and usage instructions at http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html.


Available states
================

.. contents::
    :local:

``loadbalancer``
------------

Installs haproxy and keepalived as configured in the pillar.

``loadbalancer.client``
------------

Appends dns info into /etc/hosts.