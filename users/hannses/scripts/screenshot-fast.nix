{ pkgs, globals, ... }:
{
  screenshot-fast = pkgs.pkgs.writeShellScript "screenshot" ''
    DMENU="${globals.dmenu}"
    screenshot_dir="$HOME/.screenshots"  #TODO globals
    mkdir "$screenshot_dir"

    get_timestamp() {
        date '+%Y%m%d-%H%M%S'
    }
    targetCMD="area"
    outputCMD="copy"

    timer="1"
    sleep $timer
    grimblast --notify $outputCMD $targetCMD "$screenshot_dir/$(get_timestamp).png"
  '';
}
