{ inputs }:
final: prev: {
  td = prev.buildGoModule rec {
    pname = "td";
    version = "0.42.0";

    src = inputs.td;
    proxyVendor = true;
    vendorHash = "sha256-6OMT5nGoEFRkaQjh1SLBn8rfHZfcOlD0C+foZu6VhLY=";

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
