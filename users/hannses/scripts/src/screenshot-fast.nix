{ globals, lib, hm-config, ... }: ''
  DMENU="${globals.dmenu}"
  screenshot_dir="$HOME/.screenshots"  #TODO globals
  mkdir "$screenshot_dir"

  get_timestamp() {
      date '+%Y%m%d-%H%M%S'
  }
  targetCMD="area"
  outputCMD="copy"

  ${lib.optionalString hm-config.services.wlsunset.enable
  "systemctl --user stop wlsunset.service"}
  grimblast --notify $outputCMD $targetCMD "$screenshot_dir/$(get_timestamp).png"
  ${lib.optionalString hm-config.services.wlsunset.enable
  "systemctl --user start wlsunset.service"}
''
