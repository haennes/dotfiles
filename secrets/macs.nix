{ ... }: {
  #private mac "subnet"
  #https://en.wikipedia.org/wiki/MAC_address#IEEE_802c_local_MAC_address_usage
  macs = {
    vm-host."02" = {
      # use for vms
      "01" = {
        "00:00:00:01" = "vm-fons%eth0";
        "00:00:00:02" = "vm-tabula%eth0";
      };
    };
  };
}
