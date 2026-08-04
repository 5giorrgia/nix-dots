{ config, pkgs, ... }:

{
  home.packages = [ pkgs.git pkgs.gh ];
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "5giorgia";
        email = "197061464+5giorrgia@users.noreply.github.com";
      };
      credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      credential."https://gist.github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
  };
}
