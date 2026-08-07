{ config, ... }:

{
  services = {
    gvfs.enable = true;
    udisks2.enable = true;
    ratbagd.enable = true;
    usbmuxd.enable = true;
  };
}
