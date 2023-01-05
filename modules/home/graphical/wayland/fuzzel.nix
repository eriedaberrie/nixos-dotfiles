{ pkgs, config, lib, theme, ... }:

let
  cfg = config.my.graphical.wayland.fuzzel;
in {
  options.my.graphical.wayland.fuzzel = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.fuzzel ];
    xdg.configFile."fuzzel/fuzzel.ini".text = lib.generators.toINI { } {
      main = {
        font = "DejaVu Sans Mono:size=10";
        icon-theme = "Papirus-Dark";
        show-actions = true;
        terminal = "kitty -e";
        width = 50;
        horizontal-pad = 50;
        vertical-pad = 20;
        inner-pad = 15;
        line-height = 16;
      };
      colors = builtins.mapAttrs (_: val: "${val}FF") (with theme; {
        background = mantle;
        text = overlay2;
        match = blue;
        selection = surface0;
        selection-text = text;
        selection-match = teal;
        border = teal;
      });
      key-bindings = {
        cursor-left = "Left Control+b Mod1+h";
        cursor-right = "Right Control+f Mod1+l";
        delete-prev = "BackSpace Control+h";
        delete-prev-word = "Mod1+BackSpace Control+BackSpace Control+w";
        delete-next = "Delete";
        delete-line = "none";
        prev = "Up Control+p Control+k";
        prev-page = "KP_Prior Control+u";
        next = "Down Control+n Control+j";
        next-page = "KP_Next Control+d";
      };
      border.width = 2;
    };
  };
}
