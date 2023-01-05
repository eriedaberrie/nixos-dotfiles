{ config, lib, ... }:

let
  cfg = config.my.graphical.kitty;
in {
  options.my.graphical.kitty = {
    enable = lib.mkEnableOption null // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      theme = "Catppuccin-Mocha";
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 10.5;
      };
      keybindings = {
        "ctrl+backspace" = "send_text all \\x1b\\x7f";
      };
      settings = {
        window_margin_width = 5;
        focus_follows_mouse = "yes";
        shell_integration = "no-cursor";
      };
    };
  };
}
