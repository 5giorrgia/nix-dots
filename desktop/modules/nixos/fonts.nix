{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    maple-mono.NF-CN
    liberation_ttf
    comfortaa
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "Maple Mono NF" "Noto Sans CJK JP" ];
      sansSerif = [ "Comfortaa" "Noto Sans" "Noto Sans CJK JP" ];
      serif     = [ "Noto Serif" "Noto Serif CJK JP" ];
      emoji     = [ "Noto Color Emoji" ];
    };
  };
}
