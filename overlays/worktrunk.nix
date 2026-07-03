{ inputs }:
final: prev: {
  worktrunk = inputs.worktrunk.packages.${prev.stdenv.hostPlatform.system}.default;
}
