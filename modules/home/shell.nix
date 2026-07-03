{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      scan_timeout = 200;
      command_timeout = 1000;
    };
  };
}
