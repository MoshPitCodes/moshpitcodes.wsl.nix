{ pkgs, lib, ... }:
let
  # Single source of truth for language enablement. Consumed here for LSP/tool
  # packages and by modules/home/nvim.nix (via _module.args.lspLanguages) for
  # the matching nvf language modules.
  # Note: rust has no package block on purpose — rust-analyzer/clippy/rustfmt
  # come from rustup (modules/home/dev.nix).
  languages = {
    c-cpp = true;
    css = true;
    go = true;
    html = false;
    java = true;
    javascript-typescript = true;
    lua = true;
    nix = true;
    python = true;
    rust = true;
    shell = true;
    yaml = true;
    zig = false;
  };

  lspPackages =
    with pkgs;
    lib.optionals languages.c-cpp [
      clang-tools
      cmake-language-server
    ]
    ++ lib.optionals languages.css [
      vscode-langservers-extracted
    ]
    ++ lib.optionals languages.go [
      gopls
      golangci-lint
      gofumpt
      delve
    ]
    ++ lib.optionals languages.java [
      jdt-language-server
    ]
    ++ lib.optionals languages.javascript-typescript [
      typescript-language-server
      vscode-langservers-extracted
      tailwindcss-language-server
      prettierd
    ]
    ++ lib.optionals languages.lua [
      lua-language-server
      stylua
    ]
    ++ lib.optionals languages.nix [
      nixd
      nil
      nixfmt
      statix
      deadnix
    ]
    ++ lib.optionals languages.python [
      pyright
      ruff
    ]
    ++ lib.optionals languages.shell [
      shellcheck
      shfmt
      bash-language-server
    ]
    ++ lib.optionals languages.yaml [
      yaml-language-server
    ];

  devTools = with pkgs; [
    gdb
    gnumake
    cmake
    meson
    ninja
    pre-commit
  ];
in
{
  home.packages = lspPackages ++ devTools;

  _module.args.lspLanguages = languages;
}
