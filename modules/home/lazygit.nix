# lazygit - terminal git UI (theme colors from modules/home/theme.nix)
{ palette, ... }:
{
  programs.lazygit = {
    enable = true;
    settings.gui = {
      nerdFontsVersion = "3";
      theme = {
        activeBorderColor = [
          palette.aqua
          "bold"
        ];
        inactiveBorderColor = [ palette.grey1 ];
        searchingActiveBorderColor = [
          palette.yellow
          "bold"
        ];
        optionsTextColor = [ palette.blue ];
        selectedLineBgColor = [ palette.bgSelection ];
        cherryPickedCommitFgColor = [ palette.blue ];
        cherryPickedCommitBgColor = [ palette.bgSelection ];
        markedBaseCommitFgColor = [ palette.blue ];
        markedBaseCommitBgColor = [ palette.bgSelection ];
        unstagedChangesColor = [ palette.red ];
        defaultFgColor = [ palette.fg ];
      };
    };
  };
}
