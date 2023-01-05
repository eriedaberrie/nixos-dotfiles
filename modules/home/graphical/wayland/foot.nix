{ pkgs, config, lib, ... }:

let
  cfg = config.my.graphical.wayland.foot;
in {
  options.my.graphical.wayland.foot = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
    };
    xdg.configFile."foot/foot.ini".text = builtins.readFile (pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "foot";
      rev = "79ab526a1428318dba793d58afd1d2545ed3cb7c";
      sha256 = "1lq7s2909xxxlmjcg5bkix7dw3js8j2khvzxpq3lny51aqifz222";
    } + "/catppuccin-mocha.conf") + lib.generators.toINI { } {
      main = {
        font = "JetbrainsMono Nerd Font:size=8";
      };
    };
  };
}
