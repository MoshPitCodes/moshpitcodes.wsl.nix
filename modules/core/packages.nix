# Minimal system-wide bootstrap tools (usable by root and during recovery).
# Everything user-facing is managed per-user via home-manager (modules/home).
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    file
    git
    openssh
    rsync
    vim
    wget
  ];
}
