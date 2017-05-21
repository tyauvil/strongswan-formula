{%- from 'strongswan/settings.sls' import strongswan with context -%}

/etc/ipsec.conf:
  file.managed:
    - source: salt://strongswan/templates/ipsec.conf
    - template: jinja
    - context:
        esp : {{ strongswan.esp }}
        ike : {{ strongswan.ike }}
        keyexchange : {{ strongswan.keyexchange }}
    - listen_in:
        - service: strongswan

/etc/ipsec.secrets:
  file.managed:
    - source: salt://strongswan/templates/ipsec.secrets
    - template: jinja
    - listen_in:
        - service: strongswan

/etc/strongswan.d/charon/kernel-netlink.conf:
  file.managed:
    - source: salt://strongswan/files/kernel-netlink.conf
    - makedirs: True
    - listen_in:
        - service: strongswan

/etc/strongswan.d/charon.conf:
  file.managed:
    - source: salt://strongswan/files/charon.conf
    - listen_in:
        - service: strongswan

{% for tunnel, value in salt['pillar.get']('strongswan:tunnels', {}).iteritems() -%}

{{ value['vti_name'] }}_ifup:
  cmd.script:
    - source: salt://strongswan/files/vti-ifup.sh
    - env:
      - VTI_NAME: "{{ value['vti_name'] }}"
      - LOCAL: "{{ salt['network.interface_ip']('eth0') }}"
      - REMOTE: "{{ value['right'] }}"
      - REMOTE_SUBNET: "{{ value['remote_subnet'] }}"
      - INSIDE_IP: "{{ value['inside_ip']}}"
      - REMOTE_IP: "{{ value['remote_ip']}}"
      - KEY: "{{ value['key']}}"
      - MTU: "{{ strongswan.mtu }}"
    - unless: /sbin/ip a show "{{ value['vti_name'] }}" | grep -q UP

net.ipv4.conf.{{ value['vti_name'] }}.accept_source_route:
  sysctl.present:
    - value: 0

net.ipv4.conf.{{ value['vti_name'] }}.disable_policy:
  sysctl.present:
    - value: 1

net.ipv4.conf.{{ value['vti_name'] }}.disable_xfrm:
  sysctl.present:
    - value: 0

{% endfor %}

strongswan:
  pkg.installed: []
  service.running:
    - enable: True
