{
  programs.bash = {
    enable = true;

    shellAliases = {
      "nixp" = "nvim ~/nix-dots/desktop/modules/home/packages.nix";
      "nixe" = "sudo nix-collect-garbage -d; sudo nixos-rebuild switch --flake ~/nix-dots#desktop";
      "nixr" = "sudo nixos-rebuild switch --flake ~/nix-dots#desktop";
      "noctalia-config" = "rm -rf ~/nix-dots/desktop/modules/home/noctalia/config.toml; noctalia config export full >> ~/nix-dots/desktop/modules/home/noctalia/config.toml; sudo nixos-rebuild switch --flake ~/nix-dots#desktop";
    };

    initExtra = ''
      nixu() {
        local current_dir=$(pwd)
        cd ~/nix-dots
        sudo nix flake update
        sudo nixos-rebuild switch --flake ~/nix-dots#desktop
        cd "$current_dir"
      }

      nixg() {
        local msg="''${1:-latest}"
        (cd ~/nix-dots && git add . && git commit -m "$msg" && git push)
      }

      PS1='\[\e[38;5;39m\] \[\e[38;5;75m\]~ \[\e[38;5;213m\]''${USER^}\[\e[38;5;75m\] in \[\e[38;5;123m\]\w \[\e[38;5;213m\]➜ \[\e[0m\]'
    '';
  };
}
