{ config, pkgs, ... }:

{
  programs = {
    gamemode.enable = true;
    gamescope = {
      enable = true;
      enableWsi = true;
      capSysNice = false;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
