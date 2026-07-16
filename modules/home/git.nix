{
  customsecrets,
  lib,
  pkgs,
  ...
}:
let
  gitSecrets = customsecrets.git or { };
  signingKey = gitSecrets.signingKey or "";
  ghConfigDir = customsecrets.ghConfigDir or "";
in
{
  programs.git = {
    enable = true;

    signing = lib.mkIf (signingKey != "") {
      key = signingKey;
      signByDefault = true;
    };

    settings = {
      user = {
        name = gitSecrets.userName or "MoshPitCodes";
        email = gitSecrets.userEmail or "moshpitcodes@example.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = {
        autocrlf = "input";
        editor = "nvim";
      };
      gpg.format = "ssh";
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  # Restore gh credentials only on first bootstrap. hosts.yml is where gh
  # stores the OAuth token; restoring it unconditionally would clobber any
  # token minted by `gh auth login` after the backup was taken (same
  # first-bootstrap pattern as modules/home/gpg.nix). To force a re-restore,
  # remove ~/.config/gh/hosts.yml before rebuilding.
  home.activation.ghAuth = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -n "${ghConfigDir}" ] && [ -f "${ghConfigDir}/hosts.yml" ] \
       && [ ! -f "$HOME/.config/gh/hosts.yml" ]; then
      install -d -m 0700 "$HOME/.config/gh"
      cp --no-preserve=mode "${ghConfigDir}/hosts.yml" "$HOME/.config/gh/hosts.yml"
      chmod 600 "$HOME/.config/gh/hosts.yml"
      echo "Restored gh CLI authentication from backup"
    fi

    if ! ${pkgs.gh}/bin/gh auth status >/dev/null 2>&1; then
      echo "gh CLI not authenticated. Run: gh auth login --hostname github.com --git-protocol ssh --web"
    fi
  '';
}
