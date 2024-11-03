{ ... }: {
  #private mac "subnet"
  #https://en.wikipedia.org/wiki/MAC_address#IEEE_802c_local_MAC_address_usage
  macs = {
    vm-host."02" = {
      # use for vms
      "01" = {
        "00:00:00:01" = "fons%eth0";
        "00:00:00:02" = "tabula%eth0";
        "00:00:00:03" = "historia%eth0";
        "00:00:00:04" = "minerva%eth0";
        "00:00:00:05" = "vertumnus%eth0";
        "00:00:00:06" = "concordia%eth0";
      };
    };
  };
}
