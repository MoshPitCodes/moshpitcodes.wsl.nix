{ inputs }:
_final: prev: {
  td = prev.buildGoModule rec {
    pname = "td";
    # Keep in sync with the `td` input tag in flake.nix; a bump also needs a
    # new vendorHash.
    version = "0.51.0";

    src = inputs.td;
    proxyVendor = true;
    vendorHash = "sha256-F8G/peY9N/eQzX9s7mUsMj37TyzAjrehDGaho5gENYc=";

    subPackages = [ "." ];

    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
    ];

    env.CGO_ENABLED = "1";

    meta = with prev.lib; {
      description = "Task management CLI for AI-assisted development";
      homepage = "https://github.com/marcus/td";
      license = licenses.mit;
      mainProgram = "td";
      platforms = platforms.unix;
    };
  };
}
