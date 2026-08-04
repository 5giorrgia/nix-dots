{ config, ... }:

{
  services = {
    xserver.enable = false;
    xserver.xkb = {
      layout = "it";
      variant = "";
    };
  };
  console.keyMap = "it2";
}
