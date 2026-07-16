# Installation Guide

> [!CAUTION]
> Customizing system configurations may lead to unforeseen effects and potentially
> disrupt your system's standard operations. You **must** examine the configuration
> details and adjust them to your requirements before proceeding.

## Prerequisites

- Windows 10/11 with WSL2 enabled
- Basic familiarity with the command line

## 1. Install NixOS-WSL

Install the NixOS-WSL distribution into WSL. The upstream project ships a
prebuilt tarball import; see the
[NixOS-WSL README](https://github.com/nix-community/NixOS-WSL) for the current
commands. In short:

```powershell
# In an elevated PowerShell (Windows)
wsl --install --from-file nixos.wsl
wsl -d NixOS
```

This imports a NixOS rootfs into WSL2 and boots it once with a default
configuration.

## 2. Clone the Repository

From inside the running NixOS-WSL instance:

```bash
nix-shell -p git --run "git clone https://github.com/MoshPitCodes/moshpitcodes.wsl.nix ~/Code/MoshPitCodes/moshpitcodes.wsl.nix"
cd ~/Code/MoshPitCodes/moshpitcodes.wsl.nix
```

## 3. Configure Secrets

Copy the secrets template and fill in your values:

```bash
cp secrets.nix.example secrets.nix
```

Edit `secrets.nix` to configure at minimum:

- **username** - Your system user
- **git** - Name, email, and optional signing key

Optional (leave empty/absent to keep the matching modules inert):

- **apiKeys** - `anthropic`, `openai`, `openrouter` for AI coding agents
- **nas** / **samba** - host, share, and credentials for the lazy CIFS NAS mount
- **sshKeys** / **gpgDir** / **ghConfigDir** - NAS backup paths for first-boot key/credential restore
- **backup.nasBackupPath** - destination for the daily `~/Code` backup

See [SECRETS.md](../SECRETS.md) for the full schema and runtime/Doppler usage.

> `secrets.nix` is git-ignored and should **never** be committed.

## 4. Apply the Configuration

Rebuild with the `wsl` host **from the repo root**. `--impure` is required
because `secrets.nix` is loaded through impure path resolution in `flake.nix`;
if `secrets.nix` is missing, evaluation fails with instructions (there is no
silent fallback):

```bash
sudo nixos-rebuild switch --flake .#wsl --impure
# or, once available:
just rebuild      # via the repo justfile
rebuild           # zsh alias
```

## 5. (Re)start the WSL instance

After the first successful rebuild, restart the distro so the new
`/etc/wsl.conf` and systemd settings take effect:

```powershell
wsl --terminate NixOS
wsl -d NixOS
```

## Next Steps

- [Configuration Guide](configuration.md) - Customize your WSL setup
- [Development Shells](development-shells.md) - Set up dev environments
