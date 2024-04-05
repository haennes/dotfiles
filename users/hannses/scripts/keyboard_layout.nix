{ pkgs, globals, ... }:
{
  keyboard_layout = pkgs.pkgs.writeShellScript "keyboard_layout" ''
    DMENU="${globals.dmenu}"

    devices=($(hyprctl devices | grep -Pzo '(?s)Keyboards.*rules' | awk '{print $1}' | tail -n +3 | awk 'NR == 1 || (NR -1) % 5 == 0'))

    selected_device=$(echo "all ''${devices[@]}" | tr ' ' '\n' | $DMENU)

    if [ ! "$selected_device" = "all" ]; then
        unset devices
        devices=$selected_device
    fi

    kb_layouts=$(hyprctl devices | grep -Pzo '(?s)Keyboards.*active keymap' | sed -n 4p | awk '{print $7}' | sed 's/.*\"\(.*\)\".*/\1/')

    layout_index=$(echo -e "$kb_layouts" | tr ',' '\n' | $DMENU -format 'i')


    for device in "''${devices[@]}"; do
        hyprctl switchxkblayout "$device" $layout_index
    done
  '';
}
