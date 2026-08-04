{ config, ... }:

{
  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    gnome.gnome-keyring.enable = true;
  };
  programs.niri.enable = true;
  security.polkit.enable = true;
  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
  };
}
