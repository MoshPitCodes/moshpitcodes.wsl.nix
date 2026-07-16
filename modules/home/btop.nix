# Btop system monitor configuration (theme colors from modules/home/theme.nix)
{ palette, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "everforest";
      shown_boxes = "cpu mem net proc";
      vim_keys = true;
      rounded_corners = true;
      theme_background = false;
    };
  };

  xdg.configFile."btop/themes/everforest.theme".text = ''
    # Main background
    theme[main_bg]="${palette.bg}"

    # Main text color
    theme[main_fg]="${palette.fg}"

    # Title color for boxes
    theme[title]="${palette.fg}"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="${palette.red}"

    # Background color of selected items
    theme[selected_bg]="${palette.bgSelection}"

    # Foreground color of selected items
    theme[selected_fg]="${palette.yellow}"

    # Color of inactive/disabled text
    theme[inactive_fg]="${palette.bg}"

    # Color of text appearing on top of graphs
    theme[graph_text]="${palette.fg}"

    # Misc colors for processes box
    theme[proc_misc]="${palette.green}"

    # Box outline colors
    theme[cpu_box]="${palette.bgSelection}"
    theme[mem_box]="${palette.bgSelection}"
    theme[net_box]="${palette.bgSelection}"
    theme[proc_box]="${palette.bgSelection}"

    # Box divider line and small boxes line color
    theme[div_line]="${palette.bgSelection}"

    # Temperature graph colors
    theme[temp_start]="${palette.green}"
    theme[temp_mid]="${palette.yellow}"
    theme[temp_end]="${palette.brightRed}"

    # CPU graph colors
    theme[cpu_start]="${palette.green}"
    theme[cpu_mid]="${palette.yellow}"
    theme[cpu_end]="${palette.brightRed}"

    # Mem/Disk free meter
    theme[free_start]="${palette.brightRed}"
    theme[free_mid]="${palette.yellow}"
    theme[free_end]="${palette.green}"

    # Mem/Disk cached meter
    theme[cached_start]="${palette.blue}"
    theme[cached_mid]="${palette.aqua}"
    theme[cached_end]="${palette.green}"

    # Mem/Disk available meter
    theme[available_start]="${palette.brightRed}"
    theme[available_mid]="${palette.yellow}"
    theme[available_end]="${palette.green}"

    # Mem/Disk used meter
    theme[used_start]="${palette.green}"
    theme[used_mid]="${palette.yellow}"
    theme[used_end]="${palette.brightRed}"

    # Download graph colors
    theme[download_start]="${palette.green}"
    theme[download_mid]="${palette.aqua}"
    theme[download_end]="${palette.blue}"

    # Upload graph colors
    theme[upload_start]="${palette.yellow}"
    theme[upload_mid]="${palette.orange}"
    theme[upload_end]="${palette.red}"

    # Process box color gradient for threads, mem and cpu usage
    theme[process_start]="${palette.green}"
    theme[process_mid]="${palette.red}"
    theme[process_end]="${palette.brightRed}"
  '';
}
