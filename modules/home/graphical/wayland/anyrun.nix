{ pkgs, config, lib, osConfig, theme, inputs, ... }:

let
  cfg = config.my.graphical.wayland.anyrun;
in {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  options.my.graphical.wayland.anyrun = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          rink
          inputs.anyrun-nixos-options.packages.${pkgs.system}.default
        ];
        y.fraction = 0.15;
        width.fraction = 0.45;
        hideIcons = false;
        ignoreExclusiveZones = true;
        layer = "top";
        hidePluginInfo = true;
        closeOnClick = true;
        showResultsImmediately = true;
        maxEntries = 8;
      };
      extraCss = with theme; ''
        * {
          all: unset;
          color: #${text};
          font: 20px Inter;
        }

        label#match-desc {
          font-size: 16px;
          color: #${subtext0};
        }

        box#main {
          background-color: #${crust};
          border: 3px solid #${teal};
          border-radius: 15px;
        }

        entry#entry {
          background-color: #${base};
          border-radius: 12px;
          padding: 15px;
          font-size: 24px;
        }

        list#plugin:first-child {
          margin-top: 8px;
        }

        box#match {
          background-color: #${mantle};
          border-radius: 10px;
          padding: 6px;
          margin: 0px 6px 6px;
        }

        image#match {
          background-color: #${mantle};
          padding: 8px;
          border-radius: 24px;
          margin: 10px;
        }

        row#match:selected box#match,
        row#match:hover box#match {
          background-color: #${teal};
        }

        row#match:selected label,
        row#match:hover label {
          color: #${mantle};
        }
      '';
      extraConfigFiles = {
        "applications.ron".text = ''
          Config(
            desktop_actions: true,
            max_entries: 8,
            terminal: Some("kitty"),
          )
        '';
        "nixos-options.ron".text = ''
          Config(
            options_path: "${osConfig.system.build.manual.optionsJSON}/share/doc/nixos/options.json"
          )
        '';
      };
    };
  };
}
