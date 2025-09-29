{ ... }: ''
  current_monitor=$(hyprctl activeworkspace | head -n 1 | awk '{print $7}')

  # remove ":" from string
  current_monitor=\$\{current_monitor//:}

  monitors=($(hyprctl monitors | grep "Monitor" | awk '{print $2}'))

  monitor_amount=\$\{#monitors[@]}

  for i in "\$\{!monitors[@]}"; do
      if [[ "\$\{monitors[$i]}" = "\$\{current_monitor}" ]]; then
          current_monitor_index=\$\{i};
      fi
  done

  # next
  if (( $current_monitor_index == $monitor_amount-1 )); 
  then
      next_index=0
  else
      next_index=$((current_monitor_index + 1))
  fi

  # prev
  if [[ $current_monitor_index = 0 ]];
  then
      prev_index=$((monitor_amount - 1))
  else
      prev_index=$((current_monitor_index - 1))
  fi

  getopts "np" flag
  case "\$\{flag}" in
      n)
          hyprctl dispatch focusmonitor \$\{monitors[$next_index]}
          ;;
      p)
          hyprctl dispatch focusmonitor \$\{monitors[$prev_index]}
          ;;
  esac
''
