{ flake, lib, ... }: {
  programs.wezterm = {
    enable = true;
    # font = wezterm.font "Comic Code Ligatures",
    extraConfig = ''
        local wezterm = require("wezterm")
        local config = wezterm.config_builder()
        local act = wezterm.action

        config = {
          window_background_opacity = 0.6,
      color_scheme = "Tokyo Night Moon",

          window_padding = {
            left = 0,
            right = 0,
            bottom = 0,
            top = 0,
          },

          animation_fps = 30,
          default_cursor_style = 'BlinkingBlock',
          cursor_blink_ease_in = 'EaseIn',
          cursor_blink_ease_out = 'EaseOut',


          mouse_bindings = {
            {
              event = { Down = { streak = 1, button = { WheelUp = 1 } } },
              mods = 'NONE',
              action = act.ScrollByLine(-3),
            },
            {
              event = { Down = { streak = 1, button = { WheelDown = 1 } } },
              mods = 'NONE',
              action = act.ScrollByLine(3),
            },
          },

          leader = { key = 'Space', mods = 'SHIFT', timeout_milliseconds = 1000 },

          keys = {
            {
              key = 'c',
              mods = 'LEADER',
              action = act.SpawnTab 'CurrentPaneDomain',
            },
            {
              key = "d"
              modes = 'LEADER',
              action = wezterm.action.CloseCurrentTab { confirm = true },
            },
            {
              key = "P",
              mods = "LEADER",
              action = act.MoveTabRelative(-1),
            },
            {
              key = "N",
              mods = "LEADER",
              action = act.MoveTabRelative(1),
            },
            {
              key = "p",
              mods = "LEADER",
              action = act.ActivateTabRelative(-1),
            },
            {
              key = "n",
              mods = "LEADER",
              action = act.ActivateTabRelative(1),
            },
          },
        }

        for i = 1, 9 do
          -- ctrl + space + i -> Tab
          table.insert(config.keys, {
            key = tostring(i),
            mods = 'LEADER',
            action = act.ActivateTab(i - 1),
          })
        end

        return config
    '';
  };
}
