{ pkgs, inputs, config, lib, ... }:

let
  cfg = config.my.bin-compat;
in {
  options.my.bin-compat = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      appimage-run
      inputs.nix-alien.packages.${system}.default
    ];

    programs = {
      nix-ld.enable = true;
    };
  };
}
