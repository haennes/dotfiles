{ ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      swap_disk = false;
    };
  };
}
