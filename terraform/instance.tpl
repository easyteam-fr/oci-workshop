#cloud-config

write_files:
  - path: /etc/sysctl.d/98-ip-forward.conf
    content: |
      net.ipv4.ip_forward = 0

runcmd:
  - sysctl -p /etc/sysctl.d/98-ip-forward.conf
