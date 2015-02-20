{% from "loadbalancer/map.jinja" import loadbalancer with context %}
include:
  - loadbalancer.client

loadbalancer-prereqs:
  pkg.installed:
    - names:
      - wget
      - gcc
      - openssl-devel
      - pcre-devel


loadbalancer:
  sysctl.present:
    - name: net.ipv4.ip_nonlocal_bind
    - value: 1
  pkg.installed:
    - name: haproxy
  cmd.run:
    - name: |
        cd /tmp
        wget -q http://www.haproxy.org/download/1.5/src/haproxy-1.5.5.tar.gz
        tar xzf haproxy-1.5.5.tar.gz -C /tmp
        cd haproxy-1.5.5
        make -s TARGET=linux2628 USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1
        make -s install
        ln -s -f /usr/local/sbin/haproxy /usr/sbin/haproxy
        rm -rf /tmp/haproxy*
    - unless: test -x /usr/local/sbin/haproxy
    - require:
      - pkg: haproxy
      - pkg: gcc
      - pkg: openssl-devel
      - pkg: pcre-devel
  service:
    - name: haproxy
    - enable: True
    - running
    - watch:
      - file: /etc/haproxy/haproxy.cfg
      - file: /etc/haproxy/cert.pem
    - require:
      - cmd: loadbalancer
  file:
    - name: /etc/haproxy/haproxy.cfg
    - managed
    - source: salt://loadbalancer/files/haproxy.cfg.jinja
    - template: jinja

loadbalancer-cert:
  file:
    - name: /etc/haproxy/cert.pem
    - managed
    - source: salt://loadbalancer/files/cert.pem.jinja
    - template: jinja

keepalive:
  pkg:
    - name: keepalived
    - installed
  service:
    - name: keepalived
    - enable: True
    - running
    - require:
      - pkg: keepalived
    - watch:
      - file: /etc/keepalived/keepalived.conf
  file:
    - name: /etc/keepalived/keepalived.conf
    - managed
    - source: salt://loadbalancer/files/keepalived.conf.jinja
    - template: jinja
