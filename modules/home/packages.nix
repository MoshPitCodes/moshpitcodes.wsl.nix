{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      # Source repo CLI tools kept for WSL.
      ripgrep
      fd
      eza
      jq
      yq
      tree
      unzip
      zip
      aoc-cli
      docfd
      lazydocker
      gtrash
      viu
      nitch
      nss
      openssl
      mimeo
      programmer-calculator
      streamlink
      td
      treefmt
      toipe
      ttyper
      valgrind
      wavemon
      xxd

      # Source repo system/user utilities that are useful without a desktop.
      htop
      ncdu
      killall
      man-pages
      xdg-utils
      onefetch
      ffmpeg-full

      # Terminal extras.
      cbonsai
      cmatrix
      pipes
      sl
      tty-clock

      (bat-extras.batgrep.overrideAttrs (_oldAttrs: {
        doCheck = false;
      }))

      # Password manager CLI only. The GUI package is intentionally excluded.
      _1password-cli

      # Modern CLI tools.
      tokei
      dust
      duf
      procs
      bottom
      tealdeer
      zoxide
      httpie
      doggo
      sd
      choose
      hyperfine
      glow
      nix-tree
      nix-diff
      comma

      # Source repo custom CLI overlays.
      sidecar
      worktrunk
    ]
    ++ lib.optionals (pkgs ? ffsend) [ ffsend ]
    ++ lib.optionals (pkgs ? proton-vpn-cli) [ proton-vpn-cli ]
    ++ lib.optionals (pkgs ? tdf) [ tdf ]
    ++ lib.optionals (pkgs ? woomer) [ woomer ];
}
