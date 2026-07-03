# Development Shells

This repository ships a Nix development shell for working on the flake itself.

## Default shell

**Usage:**
```bash
nix develop
# or explicitly
nix develop .#default
```

**Features:**
- Nix toolchain (`nil`, `nixfmt-rfc-style`)
- Version control (`git`, `just`)
- The formatter `nixfmt-rfc-style` (matches `formatter` in `flake.nix` and
  `treefmt.toml`)

## Formatting

The repository formatter is `nixfmt-rfc-style` (NOT plain `nixfmt`). Format the
whole tree with:

```bash
nix fmt                # uses flake.nix `formatter`
# or
treefmt                # uses treefmt.toml (also nixfmt-rfc-style)
```

`treefmt.toml` is configured as:

```toml
[formatter.nix]
command = "nixfmt-rfc-style"
includes = ["*.nix"]
```

## Editor (nvf)

`modules/home/nvim.nix` enables `nvf`, an opinionated Neovim distribution, as
the system editor (`vimAlias`/`viAlias` provide `nvim`/`vi`). It is wired to
`modules/home/language-servers.nix` via `_module.args.lspLanguages`, so the LSP
servers enabled in `language-servers.nix` are also enabled as nvf language
modules.

To change which languages get LSP + treesitter + formatting, edit the
`languages` attrset in `modules/home/language-servers.nix`.

## Common commands

```bash
nix flake check --show-trace        # validate the flake
nix flake update                    # update flake inputs
nix build .#nixosConfigurations.wsl.config.system.build.toplevel --show-trace
nix develop --command echo ok       # smoke-test the dev shell
```
