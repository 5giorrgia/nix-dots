{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.noctalia.nixosModules.default
    ./modules/nixos/boot.nix
    ./modules/nixos/cups.nix
    ./modules/nixos/fonts.nix
    ./modules/nixos/home-manager.nix
    ./modules/nixos/locale-time.nix
    ./modules/nixos/networking.nix
    ./modules/nixos/niri.nix
    ./modules/nixos/noctalia.nix
    ./modules/nixos/amd.nix
    ./modules/nixos/pipewire.nix
    ./modules/nixos/repos.nix
    ./modules/nixos/services.nix
    ./modules/nixos/steam.nix
    ./modules/nixos/users.nix
    ./modules/nixos/x11.nix
    ./drives.nix
  ];

  fileSystems."/mnt/Giochi" = {
    device = "/dev/disk/by-label/Giochi";
    fsType = "ntfs3";
    options = [
        "rw"
        "exec"
        "uid=1000"
        "gid=1000"
        "umask=000"
        "nofail"
        "x-gvfs-show"
        "x-gvfs-name=Giochi"
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
