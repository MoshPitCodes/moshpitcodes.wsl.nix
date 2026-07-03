{
  pkgs,
  lib,
  customsecrets,
  ...
}:
let
  anthropicApiKey = customsecrets.apiKeys.anthropic or "";

  claude = pkgs.writeShellScriptBin "claude" ''
    exec ${pkgs.nodejs}/bin/npx -y @anthropic-ai/claude-code@latest "$@"
  '';
in
{
  home.packages = [ claude ];

  # No "model" key here: the file is a read-only nix-store symlink, so pinning
  # a model would permanently shadow the default chosen interactively via
  # /model. Deny rules must use the Tool(pattern) form to match anything.
  home.file.".claude/settings.json" = {
    force = true;
    text = builtins.toJSON {
      permissions = {
        allow = [
          "Read"
          "Write"
          "Edit"
          "Bash"
          "WebFetch"
          "WebSearch"
        ];
        deny = [
          "Read(**/.env)"
          "Read(**/.env.*)"
          "Read(**/secrets.nix)"
          "Read(**/credentials.json)"
          "Edit(**/.env)"
          "Edit(**/secrets.nix)"
          "Edit(**/credentials.json)"
        ];
      };
    };
  };

  home.sessionVariables =
    lib.optionalAttrs (anthropicApiKey != "") {
      ANTHROPIC_API_KEY = anthropicApiKey;
    }
    // {
      CLAUDE_CODE_DISABLE_ERROR_REPORTING = "1";
      CLAUDE_CODE_DISABLE_TELEMETRY = "1";
    };

  programs.zsh.shellAliases = {
    claude-setup = ''
      echo "Setting up Claude Code with Doppler..."
      export ANTHROPIC_API_KEY=$(doppler secrets get ANTHROPIC_API_KEY --plain)
      echo "Anthropic API key loaded from Doppler"
    '';
    claude-doppler = "doppler run -- claude";
  };
}
