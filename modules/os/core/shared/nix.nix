{ config, inputs, self, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (final: prev: {
        stablePkgs = import inputs.nixpkgs-stable {
          inherit (prev) system;
          inherit (config.nixpkgs) config;
        };
      })
    ];
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
      # Cachix
      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://anyrun.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
    };
    # Make nix commands use config's flake lock
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      stable.flake = inputs.nixpkgs-stable;
    };
    nixPath = [
      "nixpkgs=/etc/nix/inputs/nixpkgs"
      "stable=/etc/nix/inputs/stable"
    ];
    extraOptions = ''
      !include ${config.age.secrets.nix-tokens.path}
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };

  environment.etc = {
    "nix/inputs/nixpkgs".source = inputs.nixpkgs.outPath;
    "nix/inputs/stable".source = inputs.nixpkgs-stable.outPath;
    "current-flake".source = self;
  };
}
