# Pi coding agent configuration
# Runs @mariozechner/pi-coding-agent via npx -y so it always resolves the
# latest release without a network fetch at activation time or a separate
# ~/.npm-global prefix. OPENAI_API_KEY is provided by coding-agents/default.nix.
{
  pkgs,
  customsecrets,
  ...
}:
let
  pi = pkgs.writeShellScriptBin "pi" ''
    exec ${pkgs.nodejs}/bin/npx -y @mariozechner/pi-coding-agent@latest "$@"
  '';
in
{
  home.packages = [ pi ];

  home.sessionVariables = {
    # Skip startup version check for faster launch
    PI_SKIP_VERSION_CHECK = "1";
  };

  # Pi config directory structure
  home.file = {
    ".pi/agent/.gitkeep".text = "";
  };

  # Shell aliases
  programs.zsh.shellAliases = {
    pi-setup = ''
      echo "Setting up pi with Doppler..."
      export ANTHROPIC_API_KEY=$(doppler secrets get ANTHROPIC_API_KEY --plain)
      export OPENAI_API_KEY=$(doppler secrets get OPENAI_API_KEY --plain)
      echo "API keys loaded from Doppler"
    '';
    pi-doppler = "doppler run -- pi";
  };
}
