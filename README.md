# moshpitcodes.wsl.nix

NixOS configuration for WSL2 on Windows 11. This follows the same broad shape as `moshpitcodes.nix`, but keeps the system side focused on WSL instead of desktop hardware, Wayland, GPU, audio, bootloader, or laptop-specific services.

## Structure

- `flake.nix` - flake entrypoint with the `wsl` NixOS configuration
- `hosts/wsl` - WSL host settings
- `modules/core` - Nix, WSL integration, user, and system packages
- `modules/home` - Home Manager shell, Git, SSH, tmux, and dev tooling
- `secrets.nix.example` - local secrets template

## Install NixOS-WSL

From Windows PowerShell:

```powershell
wsl --install --no-distribution
```

Download the latest `nixos.wsl` release from NixOS-WSL, then import or open it according to the upstream instructions. NixOS-WSL currently documents installing via the latest `nixos.wsl` release and starting it with:

```powershell
wsl -d NixOS
```

## Configure

Inside the NixOS WSL distro:

```bash
nix-shell -p git
git clone https://github.com/MoshPitCodes/moshpitcodes.wsl.nix
cd moshpitcodes.wsl.nix
cp secrets.nix.example secrets.nix
$EDITOR secrets.nix
```

Then apply the configuration:

```bash
sudo nixos-rebuild switch --flake .#wsl --impure
```

Use `--impure` when `secrets.nix` is present but intentionally git-ignored.

## Notes

- The default user comes from `secrets.nix`; without it, the fallback user is `nixos`.
- Windows drives mount under `/mnt`.
- Windows interop and Windows PATH appending are enabled.
- Systemd is enabled through `/etc/wsl.conf`.
- OpenGL/CUDA libraries from the Windows host are exposed with `wsl.useWindowsDriver`.
