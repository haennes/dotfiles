{ pkgs, scripts, globals, theme, ... }:
let
  batteryScript = pkgs.writeShellScriptBin "batteryScript" ''
    cat /sys/class/power_supply/BAT0/capacity
  '';

  mainWaybarConfig = {
    mod = "dock";
    layer = "top";
    gtk-layer-shell = true;
    height = 32;
    position = "top";

    modules-left = [ "custom/logo" "hyprland/workspaces" ];

    modules-center = [ "clock" ];

    modules-right = [
      #"hyprland/language"
      "network"
      "bluetooth"
      "pulseaudio"
      "pulseaudio#microphone"
      "cpu"
      #"custom/notification"
      "memory"
      "battery"
      "tray"
    ];

    bluetooth = {
      format = "{icon}";
      format-icons = {
        enabled = "";
        disabled = "! ";
      };
      format-connected = "";
      format-disabled = "!";
      tooltip-format = " {device_alias}";
      tooltip-format-connected = "{device_enumerate}";
      tooltip-format-enumerate-connected = " {device_alias}";
    };

    clock = {
      actions = {
        on-click-backward = "tz_down";
        on-click-forward = "tz_up";
        on-click-right = "mode";
        on-scroll-down = "shift_down";
        on-scroll-up = "shift_up";
      };
      calendar = {
        format = {
          days = "<span color='#ecc6d9'><b>{}</b></span>"; # TODO theme
          months = "<span color='#ffead3'><b>{}</b></span>"; # TODO theme
          today = "<span color='#ff6699'><b><u>{}</u></b></span>"; # TODO theme
          weekdays = "<span color='#ffcc66'><b>{}</b></span>"; # TODO theme
          weeks = "<span color='#99ffdd'><b>W{}</b></span>"; # TODO theme
        };
        mode = "year";
        mode-mon-col = 3;
        on-click-right = "mode";
        on-scroll = 1;
        weeks-pos = "right";
      };
      format = "󰥔 {:%H:%M}"; # TODO globals
      format-alt = "󰥔 {:%A, %B %d, %Y (%H:%M:%S)} "; # TODO globals
      interval = 1;
    };

    cpu = {
      format = "󰍛 {usage}%";
      format-alt = "{icon0}{icon1}{icon2}{icon3}";
      format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
      interval = 10;
    };

    "hyprland/workspaces" = {
      format = "{icon}";
      format-icons = {
        active = "";
        urgent = "";
        default = "";
      };
      format-window-separator = "";
      on-click = "activate";
      #persistent_workspaces = { "*" = 10; };
    };

    battery = {
      exec = "${batteryScript}/bin/batteryScript";
      states = {
        warning = 30;
        critical = 15;
      };

      format = "{icon} {capacity}%";
      format-icons = {
        charging = "󱐋";
        default = [ " " " " " " " " " " ];
      };
    };

    "custom/notification" = {
      tooltip = false;
      format = "{icon}";
      format-icons = {
        notification = "<span foreground='red'><sup></sup></span>";
        none = "";
        dnd-notification = "<span foreground='red'><sup></sup></span>";
        dnd-none = "";
        inhibited-notification = "<span foreground='red'><sup></sup></span>";
        inhibited-none = "";
        dnd-inhibited-notification =
          "<span foreground='red'><sup></sup></span>";
        dnd-inhibited-none = "";
      };
      return-type = "json";
      exec = "swaync-client -swb";
      on-click = "swaync-client -t -sw";
      on-click-right = "swaync-client -d -sw";
      escape = true;
    };

    "custom/gpu-usage" = {
      exec =
        "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits";
      format = "{}";
      interval = 10;
    };

    "custom/logo" = {
      exec = "echo ' '";
      on-click = "${pkgs.foot}/bin/foot";
      format = "{}";
      tooltip = false;
    };

    "hyprland/window" = {
      format = "  {}";
      rewrite = {
        "(.*) — Mozilla Firefox" = "$1 󰈹";
        "(.*)Steam" = "Steam 󰓓";
      };
      separate-outputs = true;
    };

    "hyprland/language" = {
      format = " {}";
      format-uk = "державна";
      format-en = "english";
      format-ru = "русский";
    };

    memory = {
      format = " {percentage}%";
      format-alt = " {used}GB";
      interval = 30;
      max-length = 10;
      tooltip = true;
      tooltip-format = " {used:0.1f}GB/{total:0.1f}GB";
    };

    network = {
      on-click = "${globals.term} -e nmtui";
      format-disconnected = " ";
      format-ethernet = "󱘖 ";
      format-linked = "󱘖 -";
      format-wifi = "󰤨 ";
      interval = 5;
      max-length = 30;
      tooltip-format =
        "󱘖 {essid} {ifname} {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-icons = {
        car = " ";
        default = [ "" "" "" ];
        hands-free = " ";
        headphone = " ";
        headset = " ";
        phone = " ";
        portable = " ";
      };
      format-muted = "  {volume}%";
      on-click = "${scripts.volume} -t";
      on-scroll-down = "${scripts.volume} -d";
      on-scroll-up = "${scripts.volume} -i";
      scroll-step = 5;
      tooltip-format = "{icon} {desc} {volume}%";
    };

    "pulseaudio#microphone" = {
      format = "{format_source}";
      format-source = "  {volume}%";
      format-source-muted = "  {volume}%";
      on-click = "${scripts.volume} -m";
      on-scroll-down = "${scripts.volume} -l";
      on-scroll-up = "${scripts.volume} -u";
      scroll-step = 5;
    };

    tray = {
      icon-size = 10;
      spacing = 1;
    };
  };

  css = ''
    * {
      border-radius: 7px;
      font-family: "${theme.font}";
      font-size: 16px;
      padding: 0px;
      margin: 1px 5px 1px 5px;
      background-color: transparent;
    }

    .modules-left, .modules-center, .modules-right {
      background: #${theme.background}, 30%;
      opacity: 0.6;
      border-width: 3px;
      border-radius: 10px;
      border-style: solid;
      border-color: #${theme.color_first}
    }

    window#waybar {
    }

    tooltip {
      color: #${theme.foreground};
      background-color: #${theme.background};
      border-radius: 10px;
      border-width: 2px;
      border-style: solid;
      border-color: shade(#${theme.color_second}, 1.25);
    }

    #workspaces button {
      margin: 0;
      color: #${theme.foreground};
      border: none;
      box-shadow: none;
      background: transparent;
    }

    #workspaces button:hover {
      border: none;
      box-shadow: none;
      background: transparent;
    }

    #cpu,
    #memory,
    #custom-power,
    #clock,
    #workspaces,
    #window,
    #custom-updates,
    #network,
    #bluetooth,
    #pulseaudio,
    #custom-wallchange,
    #custom-mode,
    #tray {
      color: #${theme.foreground};
      background: black;
    }

    #custom-battery {
      color: #${theme.foreground};
    }

    /* resource monitor block */

    #custom-notification {
      color: #${theme.foreground};
    }

    #battery {
      color: #${theme.foreground};
    }

    #cpu {
      color: #${theme.foreground};
      border-radius: 10px 0px 0px 10px;
      padding-left: 2px;
      padding-right: 2px;
    }

    #memory {
      color: #${theme.foreground};
      border-radius: 0px 10px 10px 0px;
      border-left-width: 0px;
      padding-left: 4px;
      padding-right: 12px;
      margin-right: 6px;
    }


    /* date time block */
    #clock {
      color: #${theme.foreground};
      padding-left: 12px;
      padding-right: 12px;
    }


    /* workspace window block */
    #workspaces {
      color: #${theme.foreground};
    }

    #window {
      /* border-radius: 0px 10px 10px 0px; */
      /* padding-right: 12px; */
    }


    /* control center block */
    #custom-updates {
      border-radius: 10px 0px 0px 10px;
      margin-left: 6px;
      padding-left: 12px;
      padding-right: 4px;
    }

    #network {
      color: #${theme.foreground};
      padding-left: 4px;
      padding-right: 4px;
    }

    #language {
      color: #${theme.foreground};
      padding-left: 9px;
      padding-right: 9px;
    }

    #bluetooth {
      color: #${theme.foreground};
      padding-left: 0px;
      padding-right: 4px;
    }

    #pulseaudio {
      color: #${theme.foreground};
      padding-left: 4px;
      padding-right: 4px;
    }

    #pulseaudio.microphone {
      color: #${theme.foreground};
      padding-left: 0px;
      padding-right: 4px;
    }


    /* system tray block */
    #custom-mode {
      border-radius: 10px 0px 0px 10px;
      margin-left: 6px;
      padding-left: 12px;
      padding-right: 4px;
    }

    #custom-logo {
      margin-left: 6px;
      padding-right: 4px;
      color: #${theme.foreground};
      font-size: 16px;
    }

    #tray {
      padding-left: 4px;
      padding-right: 4px;
    }
  '';
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
    style = css;
    settings = { mainBar = mainWaybarConfig; };
  };
}
