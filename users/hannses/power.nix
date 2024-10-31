{ ... }: {
  services.batsignal = {
    enable = true;
    extraArgs = [
      # warning levels
      "-w"
      "25"
      #"-W" "WARNING: Battery below 25%"
      "-c"
      "15"
      #"-C" "CRITICAL: Battery below 20%"
      "-d"
      "5"
      #"-D"
      #"systemctl suspend"
      # enable battery full level
      "-f"
      "95"
    ];
  };
}
