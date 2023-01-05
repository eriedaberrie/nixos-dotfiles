{ pkgs, config, lib, self, ... }:

let
  cfg = config.my.graphical;
in {
  options.my.graphical = {
    qt.enable = lib.mkEnableOption null // {
      default = true;
    };
    gtk = {
      enable = lib.mkEnableOption null // {
        default = true;
      };
      emacsKeys.enable = lib.mkEnableOption null;
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.qt.enable {
      home = {
        packages = with pkgs; [ qt5ct libsForQt5.lightly ];
        sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";
      };
      xdg.configFile = {
        "qt5ct/colors/Catppuccin-Mocha.conf".source = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "qt5ct";
          rev = "c50c9e7c6ba0ca12a107a6111b7941da94f5327c";
          sha256 = "1rfqwawy5971iz8q3c5m34r2jqsnip6wb2j8xf7zn0bn6qi97nbj";
        } + "/Catppuccin-Mocha.conf";
        "lightlyrc".text = ''
          [Style]
          AnimationsDuration=150
          DolphinSidebarOpacity=84
          WidgetDrawShadow=false
        '';
      };
    })

    (lib.mkIf cfg.gtk.enable {
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-key-theme = lib.mkIf (cfg.gtk.emacsKeys.enable) "Emacs";
        };
      };

      gtk = {
        enable = true;
        font = {
          package = pkgs.inter;
          name = "Inter";
          size = 11;
        };
        iconTheme = {
          package = self.packages.${pkgs.system}.catppuccin-papirus-folders;
          name = "Papirus-Dark";
        };
        theme = {
          package = pkgs.catppuccin-gtk.override {
            accents = [ "teal" ];
            tweaks = [ "rimless" ];
            variant = "mocha";
          };
          name = "Catppuccin-Mocha-Standard-Teal-dark";
        };
      } // lib.optionalAttrs cfg.gtk.emacsKeys.enable {
        gtk2.extraConfig = ''
            gtk-key-theme-name = "Emacs"
          '';
        gtk3.extraConfig = {
          gtk-key-theme-name = "Emacs";
        };
      };
    })
  ]);
}
