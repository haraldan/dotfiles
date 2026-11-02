# NAS NFS shares (automount on access, never block boot)
192.168.178.11:/mnt/nas_0/Data   /mnt/Data   nfs  _netdev,noauto,nofail,x-systemd.automount,x-systemd.idle-timeout=10min,x-systemd.mount-timeout=10s,soft,timeo=50  0 0
192.168.178.11:/mnt/nas_1/Media  /mnt/Media  nfs  _netdev,noauto,nofail,x-systemd.automount,x-systemd.idle-timeout=10min,x-systemd.mount-timeout=10s,soft,timeo=50  0 0
