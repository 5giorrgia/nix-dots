{ config, ... }:

{
  users.users."giorgia" = {
    isNormalUser = true;
    description = "Giorgia";
    extraGroups = [ "networkmanager" "wheel" "input" ];
  };
}
