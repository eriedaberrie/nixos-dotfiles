{ pkgs, config, lib, theme, ... }:

let
  cfg = config.my.graphical.wayland.swaylock;
in {
  options.my.graphical.wayland.swaylock = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    programs.swaylock = {
      package = with pkgs; symlinkJoin {
        name = "swaylock-effects-blur-flags";
        paths = [ swaylock-effects ];
        nativeBuildInputs = [ makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/swaylock \
            --add-flags -S \
            --add-flags --fade-in \
            --add-flags 0.3 \
            --add-flags --effect-blur \
            --add-flags 15x3
        '';
      };
      settings = with theme; {
        indicator = true;
        clock = true;
        indicator-thickness = 6;

        ignore-empty-password = true;
        show-failed-attempts = true;
        show-keyboard-layout = true;
        indicator-caps-lock = true;

        line-uses-inside = true;
        key-hl-color = crust;
        bs-hl-color = crust;

        inside-caps-lock-color = yellow;
        caps-lock-key-hl-color = yellow;
        caps-lock-bs-hl-color = yellow;
        text-caps-lock-color = crust;
        ring-caps-lock-color = crust;

        ring-ver-color = blue;
        text-ver-color = blue;

        ring-clear-color = yellow;
        text-clear-color = yellow;

        ring-wrong-color = red;
        text-wrong-color = red;

        inside-color = crust;
        inside-ver-color = crust;
        inside-clear-color = crust;
        inside-wrong-color = crust;
        ring-color = teal;

        text-color = teal;

        layout-bg-color = teal;
        layout-text-color = crust;
      };
    };
  };
}
