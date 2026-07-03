# CIFS/SMB NAS credential management + filesystem support.
# Ported from moshpitcodes.nix, minus Avahi (mDNS is unreliable over the WSL
# NAT and the NAS is addressed by IP in nas-mount.nix).
{
  pkgs,
  lib,
  customsecrets,
  ...
}:
{
  boot.supportedFilesystems = [ "cifs" ];

  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  # Mount point directory (created on activation)
  systemd.tmpfiles.rules = [
    "d /mnt/ugreen-nas 0755 root root -"
  ];

  # Write the credentials file from secrets at activation time
  system.activationScripts.sambaCredentials = lib.mkIf (customsecrets ? samba) {
    deps = [ "specialfs" ];
    text =
      let
        sambaUser = customsecrets.samba.username or "";
        sambaPass = customsecrets.samba.password or "";
        sambaDomain = customsecrets.samba.domain or "WORKGROUP";
      in
      ''
        install -d -m 0700 /root/.secrets
        tmpfile=$(mktemp /root/.secrets/.samba-credentials.XXXXXX)
        chmod 600 "$tmpfile"
        printf 'username=%s\npassword=%s\ndomain=%s\n' \
          '${sambaUser}' '${sambaPass}' '${sambaDomain}' > "$tmpfile"
        mv -f "$tmpfile" /root/.secrets/samba-credentials
      '';
  };
}
