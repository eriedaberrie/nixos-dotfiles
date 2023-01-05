{ pkgs, config, lib, ... }:

let
  cfg = config.my.cli;
in {
  options.my.cli = {
    bat.enable = lib.mkEnableOption null // {
      default = true;
    };
    btop.enable = lib.mkEnableOption null;
    exa.enable = lib.mkEnableOption null // {
      default = true;
    };
    neovim.enable = lib.mkEnableOption null;
    ranger.enable = lib.mkEnableOption null;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.bat.enable {
      programs.bat = {
        enable = true;
        config = {
          map-syntax = [ "flake.lock:JSON" ];
          theme = "catppuccinMocha";
        };
        themes = {
          catppuccinMocha = builtins.readFile (pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            sha256 = "1g2r6j33f4zys853i1c5gnwcdbwb6xv5w6pazfdslxf69904lrg9";
          } + "/Catppuccin-mocha.tmTheme");
        };
      };
      xdg.configFile."btop/themes/catppuccin_mocha.theme".source = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "btop";
        rev = "89ff712eb62747491a76a7902c475007244ff202";
        hash = "sha256-J3UezOQMDdxpflGax0rGBF/XMiKqdqZXuX4KMVGTxFk=";
      } + "/themes/catppuccin_mocha.theme";
    })

    (lib.mkIf cfg.btop.enable {
      programs.btop = {
        enable = true;
        settings = {
          vim_keys = true;
          color_theme = "catppuccin_mocha";
        };
      };
    })

    (lib.mkIf cfg.exa.enable {
      programs.exa = {
        enable = true;
        enableAliases = true;
      };
    })

    (lib.mkIf cfg.neovim.enable {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        plugins = with pkgs.vimPlugins; [ packer-nvim ];
      };
    })

    (lib.mkIf cfg.ranger.enable {
      home.packages = [ pkgs.ranger ];
      xdg.configFile."ranger/rc.conf".text = ''
        set preview_images true
        set preview_images_method kitty
      '';
    })
  ];
}
