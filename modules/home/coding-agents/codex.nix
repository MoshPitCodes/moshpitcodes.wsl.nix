{ pkgs, ... }:
let
  codex = pkgs.writeShellScriptBin "codex" ''
    exec ${pkgs.nodejs}/bin/npx -y @openai/codex@latest "$@"
  '';
in
{
  home.packages = [ codex ];

  home.file.".codex/.gitkeep".text = "";

  programs.zsh.shellAliases = {
    codex-setup = ''
      echo "Setting up Codex with Doppler..."
      export OPENAI_API_KEY=$(doppler secrets get OPENAI_API_KEY --plain)
      echo "OpenAI API key loaded from Doppler"
    '';
    codex-doppler = "doppler run -- codex";
  };
}
