{ pkgs, config, lib, ... }:

let
  cfg = config.my.graphical.obs;
in {
  options.my.graphical.obs = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = lib.optional config.my.graphical.wayland.enable pkgs.obs-studio-plugins.wlrobs;
    };
  };
}
