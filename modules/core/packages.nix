{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bat
    btop
    curl
    fd
    file
    fzf
    git
    gnupg
    htop
    jq
    just
    lazygit
    openssh
    ripgrep
    rsync
    starship
    tmux
    tree
    unzip
    vim
    wget
    yazi
    zoxide
    zsh
  ];

  programs.zsh.enable = true;
}
