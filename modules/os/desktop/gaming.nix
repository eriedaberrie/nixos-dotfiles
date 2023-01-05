{ pkgs, config, lib, ... }:

let
  cfg = config.my.desktop.gaming;
in {
  options.my.desktop.gaming = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          zstd
          openssl
        ];
      };
      remotePlay.openFirewall = true;
    };
  };
}
