{
  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    terminal = "screen-256color";
    extraConfig = ''
      set -g escape-time 10
      set -g status-position top

      # WSL2: bridge tmux copy/paste with the Windows clipboard.
      # `clip.exe` accepts stdin; `powershell.exe Get-Clipboard` writes stdout.
      # y/p prefix bindings copy/paste the tmux selection buffer to/from Windows.
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "clip.exe"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "clip.exe"
      bind-key p run "powershell.exe -NoProfile -Command 'Get-Clipboard' | tmux load-buffer - ; tmux paste-buffer"
    '';
  };
}
