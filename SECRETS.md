# Secret Management Guide

This WSL flake uses **file-based secrets** via a local `secrets.nix` file (the `customsecrets` mechanism in `flake.nix`). It does **not** use environment variables or a `lib/secrets.nix` helper.

## Quick Setup

1. **Copy the template:**
   ```bash
   cp secrets.nix.example secrets.nix
   ```

2. **Edit `secrets.nix`** with your real values (see the schema below).

3. **Rebuild.** Because `secrets.nix` is loaded through an impure path
   resolution (`FLAKE_ROOT` / `PWD`), rebuilds use `--impure`:
   ```bash
   sudo nixos-rebuild switch --flake .#wsl --impure
   # or the alias from the zsh module:
   rebuild
   ```

> `secrets.nix` is git-ignored and must **never** be committed. CI copies
> `secrets.nix.example` to `secrets.nix` so the flake still evaluates in CI.

## Schema

```nix
{
  username = "moshpitcodes";

  git = {
    userName  = "MoshPitCodes";
    userEmail = "you@example.com";
    signingKey = "";          # SSH/GPG key id; empty disables commit signing
  };

  apiKeys = {
    anthropic  = "";           # Claude Code, Kiro, OpenCode (Anthropic models)
    openai     = "";           # Codex, Pi
    openrouter = "";           # OpenCode (OpenRouter models)
  };

  # NAS mount (modules/core/nas-mount.nix - lazy CIFS mount at /mnt/ugreen-nas)
  nas = {
    host  = "192.168.178.144";  # NAS IP (mDNS not used under WSL)
    share = "personal_folder";   # SMB/CIFS share name
  };

  # Samba credentials (modules/core/samba.nix - written to
  # /root/.secrets/samba-credentials at activation; skipped if block absent)
  samba = {
    username = "nas-user";
    password = "nas-password";
    domain   = "WORKGROUP";
  };

  # Optional NAS-dependent (leave commented/empty to keep modules inert):
  # gpgDir = "/mnt/ugreen-nas/Coding/SecretsBackup2025/.gnupg";
  # backup.nasBackupPath = "/mnt/ugreen-nas/Coding/Repositories";
}
```

## What each key feeds

| Key | Consumed by | Behaviour when empty/absent |
|-----|-------------|------------------------------|
| `username` | `flake.nix`, core/home user wiring | Falls back to `"nixos"` via the `builtins.trace` fallback |
| `git.userName` / `git.userEmail` | `modules/home/git.nix` | Falls back to `MoshPitCodes` / `moshpitcodes@example.com` |
| `git.signingKey` | `modules/home/git.nix` (`signing` block) | `signByDefault` disabled via `lib.mkIf (signingKey != "")` |
| `apiKeys.anthropic` | `claude-code.nix`, `kiro-code.nix`, `opencode.nix` | `ANTHROPIC_API_KEY` not injected; load at runtime instead |
| `apiKeys.openai` | `coding-agents/default.nix`, `pi-mono.nix` | `OPENAI_API_KEY` not injected |
| `apiKeys.openrouter` | `opencode.nix` | `OPENROUTER_API_KEY` not injected |
| `nas.host` / `nas.share` | `modules/core/nas-mount.nix` | Falls back to `192.168.178.144` / `personal_folder`; the lazy CIFS mount evaluates but won't connect to a real share |
| `samba.*` | `modules/core/samba.nix` | Credential file `/root/.secrets/samba-credentials` is not written (`lib.mkIf (customsecrets ? samba)`); `cifs-utils` + mountpoint still installed |
| `gpgDir` | `modules/home/gpg.nix` | Activation script skipped entirely (`lib.mkIf (customsecrets ? gpgDir)`) |
| `backup.nasBackupPath` | `modules/home/backup-repos.nix` | Service + timer + aliases all disabled (`lib.mkIf hasBackupPath`). When set, the destructive `rsync --delete` also requires a one-time safety marker: `touch <nasBackupPath>/.moshpit-backup-target` on the NAS, otherwise backups skip until the marker exists. |

## Runtime keys with Doppler

API keys are intentionally optional in `secrets.nix`. For interactive use,
load them at runtime from Doppler instead of baking them into the system
closure. Each agent ships a `*-doppler` / `*-setup` zsh alias (defined in
`modules/home/coding-agents/`), e.g.:

```bash
claude-setup        # exports ANTHROPIC_API_KEY from Doppler
claude-doppler      # doppler run -- claude
opencode-doppler    # doppler run -- opencode
kiro-doppler        # doppler run -- kiro
pi-doppler          # doppler run -- pi
```

## Fallback behaviour

If `secrets.nix` is missing entirely, `flake.nix` evaluates a built-in
fallback (with empty `apiKeys` and `backup.nasBackupPath`) so the flake still
builds. The modules above stay inert and the system comes up headless with a
generic `nixos` user — useful for first boot and CI.
