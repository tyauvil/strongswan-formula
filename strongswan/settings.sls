{% set p    = pillar.get('strongswan', {}) %}
{% set pc   = p.get('config', {}) %}
{% set g    = grains.get('strongswan', {}) %}
{% set gc   = g.get('config', {}) %}

{%- set strongswan = {} %}
{%- do strongswan.update({
  'ike'         : p.get('ike', 'aes128-sha256-modp2048s256!'),
  'esp'         : p.get('esp', 'aes128-sha256-modp2048s256!'),
  'keyexchange' : p.get('keyexchange', 'ikev1'),
  'mtu'         : p.get('mtu', '1436'),
  'inf_cidr'    : p.get('inf_cidr', '10.7.0.0/16')
  }) %}
