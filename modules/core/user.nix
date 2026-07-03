{ pkgs, username, ... }:
{
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
