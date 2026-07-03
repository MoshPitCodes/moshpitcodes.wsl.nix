{ pkgs, lib, ... }:
let
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
      black
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

  home.sessionVariables = {
    LSP_C_CPP_ENABLED = if languages.c-cpp then "1" else "0";
    LSP_CSS_ENABLED = if languages.css then "1" else "0";
    LSP_GO_ENABLED = if languages.go then "1" else "0";
    LSP_HTML_ENABLED = if languages.html then "1" else "0";
    LSP_JAVA_ENABLED = if languages.java then "1" else "0";
    LSP_JS_TS_ENABLED = if languages.javascript-typescript then "1" else "0";
    LSP_LUA_ENABLED = if languages.lua then "1" else "0";
    LSP_NIX_ENABLED = if languages.nix then "1" else "0";
    LSP_PYTHON_ENABLED = if languages.python then "1" else "0";
    LSP_RUST_ENABLED = if languages.rust then "1" else "0";
    LSP_SHELL_ENABLED = if languages.shell then "1" else "0";
    LSP_YAML_ENABLED = if languages.yaml then "1" else "0";
    LSP_ZIG_ENABLED = if languages.zig then "1" else "0";
  };

  _module.args.lspLanguages = languages;
}
