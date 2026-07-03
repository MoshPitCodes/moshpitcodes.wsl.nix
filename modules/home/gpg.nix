# GPG key management
{
  pkgs,
  lib,
  customsecrets,
  ...
}:
{
  # Restore GPG keys from backup during activation.
  # Runs only on first bootstrap: if a keyring is already present locally,
  # the (potentially destructive) restore is skipped so keys generated or
  # trust changes made after the initial restore are not clobbered and the
  # agent is not killed on every switch. To force a re-restore, remove
  # ~/.gnupg/pubring.kbx (or pubring.gpg) before rebuilding.
  home.activation.copyGPGKeys = lib.mkIf (customsecrets ? gpgDir) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -d "${customsecrets.gpgDir}" ]; then
        if [ -e "$HOME/.gnupg/pubring.kbx" ] || [ -e "$HOME/.gnupg/pubring.gpg" ]; then
          echo "GPG keyring already present, skipping restore from ${customsecrets.gpgDir}"
        else
          # Stop all GnuPG daemons to prevent races while replacing keyring data.
          ${pkgs.gnupg}/bin/gpgconf --kill all 2>/dev/null || true

          # Create .gnupg with proper permissions
          install -d -m 0700 "$HOME/.gnupg"

          # Copy keys (--no-preserve=mode for CIFS mount compatibility)
          cp -rf --no-preserve=mode "${customsecrets.gpgDir}"/* "$HOME/.gnupg/" 2>/dev/null || true

          # Remove copied runtime lock/socket files from backups.
          # These are host/session specific and can break GPG key lookups.
          find "$HOME/.gnupg" -type f \( -name "*.lock" -o -name "S.gpg-agent*" -o -name "S.keyboxd" -o -name "S.dirmngr" -o -name ".#lk*" \) -delete 2>/dev/null || true

          # Fix permissions
          find "$HOME/.gnupg" -type d -exec chmod 700 {} \;
          find "$HOME/.gnupg" -type f -exec chmod 600 {} \;

          # Restart gpg-agent
          ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent 2>/dev/null || true
        fi
      fi
    ''
  );
}
