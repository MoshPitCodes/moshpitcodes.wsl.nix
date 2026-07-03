{ inputs }:
final: prev: {
  sidecar = prev.buildGoModule rec {
    pname = "sidecar";
    version = "0.86.0";

    src = inputs.sidecar;
    vendorHash = "sha256-vMDUw6zA6OpH866VdtCuFu2cbHt5NnA6k4WtQjZTpxs=";

    subPackages = [ "cmd/sidecar" ];

    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
    ];

    env.CGO_ENABLED = "1";

    meta = with prev.lib; {
      description = "TUI companion for AI coding workflows";
      homepage = "https://github.com/marcus/sidecar";
      license = licenses.mit;
      mainProgram = "sidecar";
      platforms = platforms.unix;
    };
  };
}
