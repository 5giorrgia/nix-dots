{ config, pkgs, ... }:

let
  proton-ge9-20 = pkgs.stdenv.mkDerivation rec {
    pname = "proton-ge9-20";
    version = "GE-Proton9-20";

    src = pkgs.fetchurl {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-jDWZ4m5aUALhs/EhGwrFa/3dbrLE3Lrn2BAnGC7TbIk=";
    };

    buildCommand = ''
      mkdir -p $out/share/steam/compatibilitytools.d/${version}
      tar -C $out/share/steam/compatibilitytools.d/${version} --strip-components=1 -xf $src
    '';
  };
in
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
      protontricks.enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
        proton-ge9-20
      ];
    };
  };
}
