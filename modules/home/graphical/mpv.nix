{ pkgs, config, lib, ... }:

let
  cfg = config.my.graphical.mpv;
in {
  options.my.graphical.mpv = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = let
      modernX = pkgs.fetchFromGitHub {
        owner = "cyl0";
        repo = "ModernX";
        rev = "ccb54f7c754969630426fb1798952023f11a06e6";
        sha256 = "0qik25ysvyfsn0wvah8g88imqf1w1b2xnjy5wk0lpd0ra6cbj0iy";
      };
    in {
      "mpv/scripts/modernx.lua".source = "${modernX}/modernx.lua";
      "mpv/fonts/Material-Design-Iconic-Font.ttf".source = "${modernX}/Material-Design-Iconic-Font.ttf";
      "mpv/scripts/thumbfast.lua".source = pkgs.substitute {
        src = pkgs.fetchFromGitHub {
          owner = "po5";
          repo = "thumbfast";
          rev = "08d81035bb5020f4caa326e642341f2e8af00ffe";
          sha256 = "092bdshrb9bkk7v71c3h0cjx41gm59v8pg6q1kqanpwn8b353vsg";
        } + "/thumbfast.lua";
        replacements = [ "--replace" "/bin/bash" "${pkgs.bash}/bin/bash" ];
      };
      "mpv/script-opts/osc.conf".text = ''
        keyboardnavigation=yes
      '';
    };
    programs.mpv = {
      enable = true;
      scripts = [ pkgs.mpvScripts.mpris ];
      config = {
        ao = "pipewire,";
        osc = false;
        border = false;
      };
    };
  };
}
