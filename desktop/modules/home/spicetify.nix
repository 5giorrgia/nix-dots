{ pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
      spicyLyrics
      volumePercentage
      catJamSynced
    ];
    theme = spicePkgs.themes.comfy;
  };
}
