{ ... }: {
  services.upower = {
    enable = true;
    criticalPowerAction = "HybridSleep";
    usePercentageForPolicy = true;
    percentageCritical = 3;
  };
}
