hostname:
{
  config,
  lib,
  inputs,
  all_modules,
  ...
}: {
  imports = all_modules;

  is_server = true;
  is_client = true;
  is_microvm = true;
  networking.hostName = hostname;

}
