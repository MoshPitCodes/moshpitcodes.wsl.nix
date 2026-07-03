{
  imports = [
    ../../modules/core
    ../../modules/core/nas-mount.nix
    ../../modules/core/samba.nix
  ];

  networking.hostName = "nixos-wsl";

  system.stateVersion = "25.05";
}
