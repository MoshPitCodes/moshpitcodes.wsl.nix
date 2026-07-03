# agent-browser - headless browser automation CLI for AI agents
# Keeps the Playwright browser bundle in Nix (pointed at via env vars) so the
# `npx agent-browser` runtime finds browsers without a separate download step.
# The driver/runtime itself comes from the npm `agent-browser` package.
# https://github.com/vercel-labs/agent-browser
{ pkgs, ... }:
let
  playwrightBrowsers = pkgs.playwright-driver.browsers;

  agent-browser = pkgs.writeShellApplication {
    name = "agent-browser";
    runtimeInputs = [ pkgs.nodejs ];
    text = ''
      export PLAYWRIGHT_BROWSERS_PATH="${playwrightBrowsers}"
      export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
      export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
      export PLAYWRIGHT_NODEJS_PATH="${pkgs.nodejs}/bin/node"

      exec npx -y agent-browser@latest "$@"
    '';
  };
in
{
  home.packages = [
    agent-browser
    playwrightBrowsers
  ];

  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${playwrightBrowsers}";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    PLAYWRIGHT_NODEJS_PATH = "${pkgs.nodejs}/bin/node";
  };
}
