{ globals, lib, hm-config, ... }: ''
  DMENU="${globals.dmenu}"
  screenshot_dir="$HOME/.screenshots"  #TODO globals
  mkdir "$screenshot_dir"

  get_timestamp() {
      date '+%Y%m%d-%H%M%S'
  }
  targetCMD="area"
  outputCMD="copy"

  ${lib.optionalString hm-config.services.wlsunset.enable ''
    running=0
    if systemctl is-active --quiet --user wlsunset ; then
      running=1
    fi
    systemctl --user stop wlsunset.service
  ''}
  grimblast --notify $outputCMD $targetCMD "$screenshot_dir/$(get_timestamp).png"
  ${lib.optionalString hm-config.services.wlsunset.enable ''
    if [[ "$running" == 1 ]]; then
    systemctl --user start wlsunset.service
    fi
  ''}
''
