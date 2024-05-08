{ pkgs, lib, config, ... }:
let
  theme = config.home-manager.extraSpecialArgs.theme;
  globals = config.home-manager.extraSpecialArgs.globals;
  scripts = config.home-manager.extraSpecialArgs.scripts;
  importNixScript = name: {
    "${name}" = (import ./${name}.nix {
      inherit pkgs config theme globals scripts lib;
    })."${name}";
  };
  importShellScript = name: {
    "${name}" =
      pkgs.pkgs.writeShellScript "${name}" "${lib.readFile ./${name}.sh}";
  };
in {
  # import file
  # https://noogle.dev/f/lib/readFile
  # replace smt from imported file
  # https://discourse.nixos.org/t/how-to-create-a-script-with-dependencies/7970/8
} // importNixScript "startup" // importShellScript "switchmonitor"
// importNixScript "monitorsetup" // importNixScript "kill"
// importNixScript "killall" // importNixScript "lock"
// importNixScript "file_selector" // importNixScript "wallpaper"
// importNixScript "volume" // importNixScript "wifi"
// importNixScript "bluetooth" // importNixScript "brightness"
// importNixScript "screenshot" // importNixScript "screenshot-fast"
// importNixScript "keyboard_layout" // importNixScript "clipboard"
// importNixScript "rem-from-clipboard" // importNixScript "clear-clipboard"
// importNixScript "selector"

// importNixScript "typst-live-custom"
