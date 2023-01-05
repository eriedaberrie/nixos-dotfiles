{ pkgs, ... }:

{
  imports = [
    ./warp-module.nix
  ];
  services.cloudflare-warp = {
    enable = true;
    package = pkgs.stablePkgs.cloudflare-warp;
  };
}
