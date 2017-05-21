# strongswan-formula

![alt text](assets/strongswan.png "strongSwan")

This is a formula for strongSwan, an open source IPSEC VPN solution.

This formula is configured entirely by pillar.

Example pillar data:
```
strongswan:
  tunnels:
    aws_<region>_tun_<tunnel_num>:
      right: '35.165.56.230' # AWS side IP of the VGW
      psk: 'pokewdpowfjiuhudhcnskdhfiuwhfiyetr93485'
      inside_ip: '169.254.15.146' # Client side IP of the point to point connection
      outside_ip: '169.254.15.145' # remote side IP of the point to point connection
      remote_subnet: '10.7.0.0/16' # remote CIDR that the VPN connects to
      vti_name: 'vti0' # sequentially numbered Virtual Tunnel Interface
      key: '101' # unique numerical ID that identifies IPsec traffic in the kernel
```
