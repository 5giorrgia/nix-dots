{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Maple Mono NF CN";
      package = pkgs.maple-mono.NF-CN;
      size = 12;
    };
    settings = {
      window_padding_width = "10";
      background_opacity = "0.5";
      background_blur = "20";
      confirm_os_window_close = "0";
    };
    keybindings = {
      "ctrl+plus" = "change_font_size all +1.0";
      "ctrl+minus" = "change_font_size all -1.0";
    };
    extraConfig = ''
      include themes/noctalia.conf
    '';
  };
}
