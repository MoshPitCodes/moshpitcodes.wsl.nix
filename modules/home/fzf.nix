# fzf - fuzzy finder with fd/bat/eza integration
# (theme colors from modules/home/theme.nix)
{ palette, ... }:
{
  programs.fzf = {
    enable = true;

    enableZshIntegration = true;
    tmux.enableShellIntegration = true;

    defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
    fileWidget.options = [
      "--preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'"
    ];
    changeDirWidget = {
      command = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
      options = [
        "--preview 'eza --tree --color=always {} | head -200'"
      ];
    };

    defaultOptions = [
      "--color=fg:-1,fg+:${palette.fg},bg:-1,bg+:${palette.bgSelection}"
      "--color=hl:${palette.green},hl+:${palette.green},info:${palette.blue},marker:${palette.yellow}"
      "--color=prompt:${palette.red},spinner:${palette.aqua},pointer:${palette.purple},header:${palette.blue}"
      "--color=border:${palette.bgBorder},label:${palette.grey2},query:${palette.fg}"
      "--border='double' --border-label='' --preview-window='border-sharp' --prompt='> '"
      "--marker='>' --pointer='>' --separator='─' --scrollbar='│'"
      "--info='right'"
    ];
  };
}
