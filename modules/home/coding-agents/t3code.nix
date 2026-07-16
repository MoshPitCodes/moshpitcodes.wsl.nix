# T3 Code - minimal web GUI that drives existing CLI coding agents
# (Codex, Claude Code, OpenCode). It is not itself an agent and has no API key
# of its own; it wraps the agents already provided by this directory, which
# pick up their keys from the environment (secrets.nix or Doppler).
# Runs via npx -y so it always resolves the latest release without a network
# fetch at activation time. `t3` serves a web UI on http://localhost:3773
# (opens fine in the Windows browser under WSL).
# https://github.com/pingdotgg/t3code
{ pkgs, ... }:
let
  t3 = pkgs.writeShellScriptBin "t3" ''
    exec ${pkgs.nodejs}/bin/npx -y t3@latest "$@"
  '';
in
{
  home.packages = [ t3 ];

  # Launch with Doppler-provided keys so the agents t3 drives inherit them.
  programs.zsh.shellAliases = {
    t3-doppler = "doppler run -- t3";
  };
}
