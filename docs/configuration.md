# Configuration Guide

This guide covers the WSL-specific parts of the `moshpitcodes.wsl.nix`
configuration and how to customize it.

## Layout

```
flake.nix            # entry point: inputs, customsecrets loader, wsl host
hosts/wsl/           # single WSL host (hostname + stateVersion)
modules/core/        # system-level: nix, packages, wsl, system (locale/tz), user
modules/home/        # Home Manager: shell, zsh, editor, agents, tools
overlays/            # local package overlays (sidecar, td, terraform, ...)
secrets.nix.example  # secret template (copy to secrets.nix)
```

## WSL integration (`modules/core/wsl.nix`)

WSL networking is self-contained here: it sets `wslConf.network.generateHosts`
and `generateResolvConf` so the WSL-managed `/etc/hosts` and `/etc/resolv.conf`
are used. The upstream `network.nix` (NetworkManager + custom nameservers) is
**intentionally excluded** because it conflicts with this WSL networking model.

Other WSL settings (interop, systemd, `useWindowsDriver`) are configured via the
`nixos-wsl` flake input's `nixosModules.default`. Tune them in
`hosts/wsl/default.nix` or `modules/core/wsl.nix`.

## System polish (`modules/core/system.nix`)

Portable system settings ported from upstream, minus anything already owned by
`nix.nix`, `flake.nix` (`allowUnfree`), or `hosts/wsl/default.nix`
(`stateVersion`):

- `time.timeZone` (default `Europe/Berlin`)
- `i18n.defaultLocale` + `extraLocaleSettings` (default `en_US.UTF-8`)
- `console.keyMap` (default `de`)

Adjust these to your locale in `modules/core/system.nix`.

## Shell (`modules/home/zsh/`)

A full zsh port with FZF-Tab, history settings, completion init, and WSL-specific
fixes (ALSA/SDL env, mouse-tracking guard under `WSL_DISTRO_NAME`, GPG_TTY).
`direnv` and `zoxide` live here (moved out of `dev.nix`).

Notable aliases (repo-aware for this WSL repo):

- `cdnix` - `cd ~/Code/MoshPitCodes/moshpitcodes.wsl.nix`
- `ns` / `rebuild` - rebuild this flake with `--impure`
- `winhome` - `cd /mnt/c/Users`

## Editor (nvf)

`modules/home/nvim.nix` enables `nvf` (a Neovim distribution) via the `nvf`
flake input. `vimAlias`/`viAlias` provide `nvim`/`vi`. Bare `neovim` was removed
from `modules/core/packages.nix` since nvf provides it.

Language enablement is synchronized with `modules/home/language-servers.nix`
through the `_module.args.lspLanguages` arg — change a language flag in
`language-servers.nix` and both the LSP servers and the nvf language module
update together.

## Secrets

See [SECRETS.md](../SECRETS.md). Secrets are file-based (`secrets.nix`),
loaded impurely, so rebuilds use `--impure`. API keys are optional; agents read
them from the environment at runtime (Doppler aliases) when not baked in.

## Coding agents (`modules/home/coding-agents/`)

Claude Code, Codex, Kilo, Kiro, OpenCode, Pi, and agent-browser (Playwright).
Most install themselves on first activation via native/npm installers so they
can self-update. API keys come from `customsecrets.apiKeys.*` (optional) or
Doppler at runtime.

## NAS mount (`modules/core/nas-mount.nix`, `modules/core/samba.nix`)

The UGREEN NAS is mounted lazily at `/mnt/ugreen-nas` via CIFS, ported from the
upstream `moshpitcodes.nix` desktop/laptop hosts. The mount uses
`noauto` + `x-systemd.automount` + `_netdev` + `nofail`, so it only mounts on
first access and never blocks WSL boot when the network or NAS is unavailable.
Credentials are written to `/root/.secrets/samba-credentials` at activation
from `customsecrets.samba` (the script runs only when the `samba` block exists).
Avahi/mDNS from upstream is omitted: WSL NAT makes mDNS unreliable and the
share is addressed by IP (`customsecrets.nas.host`).

Configure in `secrets.nix`:

```nix
nas = { host = "192.168.178.144"; share = "personal_folder"; };
samba = { username = "nas-user"; password = "nas-password"; domain = "WORKGROUP"; };
```

Without these keys the mount keeps the example defaults (it won't connect) and
the credential file is not written — safe but inert.

## NAS-dependent modules (inert by default)

- `modules/home/gpg.nix` - copies a backed-up `.gnupg` directory on activation.
  Active only when `customsecrets.gpgDir` is set.
- `modules/home/backup-repos.nix` - daily `~/Code` rsync to a NAS path
  with a systemd user service + timer. Active only when
  `customsecrets.backup.nasBackupPath` is non-empty. The `rsync --delete` run is
  guarded by a safety marker: create
  `touch <nasBackupPath>/.moshpit-backup-target` once on the NAS, otherwise the
  backup aborts (non-destructively) until the marker exists.

With the fallback `customsecrets` (no `secrets.nix`) the NAS mount and both
modules above stay completely disabled.

## Overlays

`overlays/default.nix` aggregates local package overlays (`sidecar`, `td`,
`terraform`, `worktrunk`, `switch-to-configuration`). These match upstream and
require no changes for WSL.
