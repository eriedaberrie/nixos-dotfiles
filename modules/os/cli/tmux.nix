{ config, lib, ... }:

let
  cfg = config.my.cli.tmux;
in {
  options.my.cli.tmux = {
    enable = lib.mkEnableOption null // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux.enable = true;
  };
}
