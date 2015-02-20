{% from "loadbalancer/map.jinja" import loadbalancer with context -%}
{% for host, vip in loadbalancer.vip.iteritems() %}
loadbalance-dns-{{ host }}:
  file.append:
    - name: /etc/hosts
    - text: {{ vip }} {% for key, values in loadbalancer.dns.iteritems() if key == host %}{% for value in values %} {{ value }}{% endfor %}{% endfor %}
{% endfor %}
