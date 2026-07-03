{
  customsecrets,
  lib,
  ...
}:
let
  sshKeys = customsecrets.sshKeys or { };
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."github.com" = {
      HostName = "github.com";
      User = "git";
      IdentityFile = "~/.ssh/id_ed25519_github";
      IdentitiesOnly = "yes";
    };
    settings."*" = {
      AddKeysToAgent = "yes";
      ServerAliveInterval = 60;
      ServerAliveCountMax = 3;
    };
  };

  services.ssh-agent.enable = true;

  home.activation.copySSHKeys = lib.mkIf (sshKeys ? sourceDir && sshKeys ? keys) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -d "${sshKeys.sourceDir}" ]; then
        install -d -m 0700 "$HOME/.ssh"

        for key in ${lib.escapeShellArgs sshKeys.keys}; do
          if [ -f "${sshKeys.sourceDir}/$key" ]; then
            cp --no-preserve=mode "${sshKeys.sourceDir}/$key" "$HOME/.ssh/$key"
            chmod 600 "$HOME/.ssh/$key"
          fi

          if [ -f "${sshKeys.sourceDir}/$key.pub" ]; then
            cp --no-preserve=mode "${sshKeys.sourceDir}/$key.pub" "$HOME/.ssh/$key.pub"
            chmod 644 "$HOME/.ssh/$key.pub"
          fi
        done
      fi
    ''
  );
}
