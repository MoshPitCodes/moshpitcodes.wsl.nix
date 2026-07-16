{ pkgs, username, ... }:
{
  # Required for zsh to work as a login shell (users.users.<name>.shell below).
  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
}
