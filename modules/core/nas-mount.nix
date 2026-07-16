# CIFS/SMB NAS mount for UGREEN NAS
# The `noauto` + `x-systemd.automount` + `_netdev` + `nofail` options make
# this safe under WSL: it mounts lazily on first access and never blocks boot
# when the network/NAS is unavailable.
# Inert unless customsecrets defines a `nas` block (host + share).
{ lib, customsecrets, ... }:
{
  fileSystems."/mnt/ugreen-nas" = lib.mkIf (customsecrets ? nas) {
    device = "//${customsecrets.nas.host}/${customsecrets.nas.share}";
    fsType = "cifs";
    options = [
      "credentials=/root/.secrets/samba-credentials"
      "sec=ntlmssp"
      "uid=1000"
      "gid=100"
      "file_mode=0755"
      "dir_mode=0755"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"
      "x-systemd.mount-timeout=30"
      "x-systemd.requires=network-online.target"
      "noauto"
      "vers=3.0"
      "cache=strict"
      "nounix"
      "rsize=130048"
      "wsize=130048"
      "_netdev"
      "nofail"
    ];
  };
}
