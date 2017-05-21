#!/bin/sh
set -e

echo "Bringing up $VTI_NAME interface"
echo "Remote IP $REMOTE_IP"
echo "Remote subnet $REMOTE_SUBNET"

if /sbin/ip link show "$VTI_NAME" | grep -q DOWN; then
    /sbin/ip link delete "$VTI_NAME"
fi

/sbin/ip tunnel add "$VTI_NAME" local "$LOCAL" remote "$REMOTE" mode vti key "$KEY" nopmtudisc
/sbin/ip addr add "$INSIDE_IP/30" remote "$REMOTE_IP/30" dev "$VTI_NAME"
/sbin/ip link set up "$VTI_NAME" mtu "$MTU"

echo "$VTI_NAME is now up"
