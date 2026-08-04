{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # System
    rofi
    xwayland-satellite
    nautilus
    fetch
    wl-clipboard

    # Editor
    neovim
    zed-editor

    # Social
    brave-origin
    equibop
    materialgram

    # Gaming
    heroic

    # Media
    feishin

    # VideoThumbnail
    ffmpeg
    ffmpegthumbnailer
    mpvpaper
    mpv
    libwebp
    libjxl
    librsvg
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];

  nixpkgs.config.allowUnfree = true;
}
