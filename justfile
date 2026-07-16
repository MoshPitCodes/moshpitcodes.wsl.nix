# Repo tasks. Run `just` to list them.
# Rebuilds use --impure because secrets.nix is git-ignored and resolved via
# $PWD at evaluation time (see flake.nix) — run these from the repo root.

default:
    @just --list

# Switch to the new configuration
rebuild:
    sudo nixos-rebuild switch --flake .#wsl --impure

# Build and activate, but don't add a boot entry
test:
    sudo nixos-rebuild test --flake .#wsl --impure

# Build without activating (result symlink)
build:
    nix build .#nixosConfigurations.wsl.config.system.build.toplevel --impure

# Update all flake inputs
update:
    nix flake update

# Format all Nix files
fmt:
    nix fmt .

# Lint Nix sources (statix + deadnix)
lint:
    statix check .
    deadnix .

# Evaluate all flake outputs
check:
    nix flake check --impure
