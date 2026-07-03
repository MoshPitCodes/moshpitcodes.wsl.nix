# CIFS/SMB NAS mount for UGREEN NAS
# Ported from moshpitcodes.nix. The `noauto` + `x-systemd.automount` +
# `_netdev` + `nofail` options make this safe under WSL: it mounts lazily on
# first access and never blocks boot when the network/NAS is unavailable.
{ customsecrets, ... }:
{
  fileSystems."/mnt/ugreen-nas" = {
    device = "//${customsecrets.nas.host or "192.168.178.144"}/${
      customsecrets.nas.share or "personal_folder"
    }";
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
