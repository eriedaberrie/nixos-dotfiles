{ config, self, ... }:

{
  imports = [
    ./overlays.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
    };
    extraOptions = ''
      !include ${config.age.secrets.nix-tokens.path}
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };
}
