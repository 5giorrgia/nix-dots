{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.spicetify-nix.homeManagerModules.spicetify
    ./modules/home/git.nix
    ./modules/home/gtk.nix
    ./modules/home/kitty.nix
    ./modules/home/niri.nix
    ./modules/home/noctalia.nix
    ./modules/home/packages.nix
    ./modules/home/spicetify.nix
    ./modules/home/bash.nix
    ./modules/home/neovim.nix
  ];

  home = {
    username = "giorgia";
    homeDirectory = "/home/giorgia";
    stateVersion = "26.11";
  };

  programs.home-manager.enable = true;
}
