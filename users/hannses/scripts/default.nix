{
  inputs,
  pkgs,
  lib,
  config,
  ...
}@all_inputs:
let
  theme = config.home-manager.extraSpecialArgs.theme;
  globals = config.home-manager.extraSpecialArgs.globals;
  scripts = config.home-manager.extraSpecialArgs.scripts;
  scripts_input = all_inputs // {
    inherit globals theme scripts;
  };
  importNixScript = name: value: pkgs.pkgs.writeShellScript name value;
  importShellScript = name: {
    "${name}" = pkgs.pkgs.writeShellScript "${name}" "${lib.readFile ./src/${name}.sh}";
  };
  hlib = inputs.haumea.lib;
in
lib.mapAttrs (name: value: importNixScript name value) (
  hlib.load {
    src = ./src;
    loader = hlib.loaders.default;
    inputs = scripts_input;
  }
)
// {
  startup = import ./startup.nix scripts_input; # isnt actually a shell-script
  disable_ext_monitors = pkgs.writers.writeNuBin "disable_ext_monitors" /* nu */ ''
    def disable_ext_monitors [] {
      let monitors = (hyprctl monitors -j)
      print $monitors
      let ext_monitors =  $monitors | from json | where { |e| $e.name != "eDP-1"}
      for m in $ext_monitors {
        print "disabling monitor" $m.name
        run-external "hyprctl" "keyword" "monitor" $"($m.name),disable"
      }
    }
    disable_ext_monitors 
  '';
}
