{ pkgs, config, lib, ... }:

let
  cfg = config.my.cli.fish;
in {
  options.my.cli.fish = {
    enable = lib.mkEnableOption null // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    users.defaultUserShell = pkgs.fish;
    programs.fish.enable = true;
  };
}
