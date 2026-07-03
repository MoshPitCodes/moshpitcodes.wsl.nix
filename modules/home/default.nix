{
  username,
  host,
  ...
}:
{
  imports = [
    ./bat.nix
    ./btop.nix
    ./coding-agents
    ./backup-repos.nix
    ./dev.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./language-servers.nix
    ./lazygit.nix
    ./nvim.nix
    ./packages.nix
    ./shell.nix
    ./ssh.nix
    ./tmux.nix
    ./yazi.nix
    ./zsh
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_CONFIG_HOST = host;
  };
}
