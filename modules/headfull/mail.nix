{ ... }: {
  services.davmail = {
    enable = true;
    url = "https://exchange.hs-regensburg.de/ews/exchange.asmx";
  };
}
