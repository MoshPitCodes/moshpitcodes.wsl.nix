{
  lib,
  customsecrets,
  ...
}:
let
  openaiApiKey = customsecrets.apiKeys.openai or "";
in
{
  imports = [
    ./agent-browser.nix
    ./claude-code.nix
    ./codex.nix
    ./kilo-code.nix
    ./kiro-code.nix
    ./opencode.nix
    ./pi-mono.nix
  ];

  # OPENAI_API_KEY is shared by codex and pi (both consume customsecrets.apiKeys.openai).
  home.sessionVariables = lib.optionalAttrs (openaiApiKey != "") {
    OPENAI_API_KEY = openaiApiKey;
  };
}
