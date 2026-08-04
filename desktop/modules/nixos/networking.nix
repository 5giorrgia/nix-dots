{ config, ... }:

{
  networking = {
    hostName = "desktop";
    wireless.enable = true;
    networkmanager.enable = true;
  };
}
