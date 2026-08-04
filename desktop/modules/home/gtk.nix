{ pkgs, ... }:

{
  gtk = {
    enable = true;

    font = {
      name = "Comfortaa Regular";
      package = pkgs.comfortaa;
      size = 11;
    };

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 16;
    };
  };
}
