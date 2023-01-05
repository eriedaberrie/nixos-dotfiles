{ pkgs, config, lib, inputs, self, theme, ... }:

let
  cfg = config.my.graphical.wayland.eww;
in {
  options.my.graphical.wayland.eww = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable (let
    eww = inputs.eww-tray.packages.${pkgs.system}.eww-wayland.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ (with pkgs; [ wrapGAppsHook ]);
      buildInputs = old.buildInputs ++ (with pkgs; [ glib librsvg libdbusmenu-gtk3 ]);
    });
  in {
    home.packages = [ eww ];

    xdg.configFile = let
      recReadDir = let
        realFile = f: ./${f};
      in dir: lib.concatMapAttrs (file: type: let
        fullFile = "${dir}/${file}";
      in
        if type == "directory" then recReadDir fullFile
        else {${fullFile} = realFile fullFile;}
      ) (builtins.readDir (realFile dir));
      filteredFiles = lib.filterAttrs (name: _:
        builtins.match ".*\\.nix" name == null
      ) (recReadDir ".");
    in builtins.mapAttrs (name: src: {
      source = pkgs.substituteAll ({
        inherit src;
        acpi = "${pkgs.acpi}/bin/acpi";
        hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
        ruby = "${self.packages.${pkgs.system}.ruby}/bin/ruby";
      } // theme);
      target = "eww/${name}";
      executable = builtins.match "\\./scripts/.*" name != null;
    }) filteredFiles // {
      "eww/_mocha.scss".text = builtins.concatStringsSep "\n"
        (lib.mapAttrsToList (name: value: "\$${name}: #${value};") theme);
    };

    systemd.user = {
      services = {
        eww = {
          Unit = {
            Description = "Eww background daemon";
            After = "hyprland-session.target";
          };
          Service = {
            Environment = "PATH=${lib.makeBinPath (with pkgs; [ coreutils bash ])}";
            ExecStart = "${eww}/bin/eww daemon --no-daemonize";
          };
          Install = {
            WantedBy = [ "hyprland-session.target" ];
          };
        };

        eww-bar = {
          Unit = {
            Description = "Eww bar";
            After = "eww.service";
          };
          Service = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "eww-bar-open" ''
              # Lack of quotes intentional
              exec ${eww}/bin/eww open-many \
                $(${config.wayland.windowManager.hyprland.package}/bin/hyprctl monitors -j | \
                  ${pkgs.jaq}/bin/jaq -r '.[] | .id' | \
                  ${pkgs.gnused}/bin/sed 's/^/bar/')
            '';
          };
          Install = {
            WantedBy = [ "eww.service" ];
          };
        };
      };

      targets.tray = {
        Unit = {
          Description = "Home Manager System Tray";
          Requires = [ "graphical-session-pre.target" ];
        };
      };
    };
  });
}
