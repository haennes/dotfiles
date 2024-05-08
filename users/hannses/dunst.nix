{ pkgs, theme, ... }: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "10x50";
        origin = "top-right";
        follow = "keyboard";
        # doesn't work 
        #transparency = 10;
        frame_color = "#${theme.color_second}99";
        corner_radius = 10;
        font = "${theme.font}";
        notification_limit = 0;
        padding = 9;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 3;
        separator_color = "frame";

        icon_position = "left";
        max_icon_size = 40;
      };
      urgency_low = {
        background = "#${theme.background}99";
        foreground = "#${theme.foreground}";
        timeout = 3;
      };
      urgency_normal = {
        background = "#${theme.background}99";
        foreground = "#${theme.foreground}";
        timeout = 3;
      };
      urgency_critical = {
        background = "#900000ff"; # TODO theme
        foreground = "#ffffffff"; # TODO theme
        frame_color = "#ff0000"; # TODO theme
        timeout = 10;
      };
    };
  };
}
