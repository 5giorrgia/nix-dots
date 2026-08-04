{ inputs, config, ... }:

{
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.giorgia = ../../home.nix;
  };
}
