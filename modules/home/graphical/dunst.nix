{ pkgs, config, lib, theme, inputs, self, ... }:

let
  cfg = config.my.graphical.dunst;
in {
  options.my.graphical.dunst = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable (let
    volumeTag = "my-volume";
    brightnessTag = "my-brightness";
    dunstify = "${config.services.dunst.package}/bin/dunstify";
    dunstVolume = let
      wpctl = "${pkgs.wireplumber}/bin/wpctl";
    in pkgs.writeShellScriptBin "dunst-volume" ''
      SINK="''${3:-@DEFAULT_AUDIO_SINK@}"
      ${wpctl} "$1" $SINK "$2"
      VOLUME_DATA="$(${wpctl} get-volume $SINK)"
      VOLUME="$(awk '{print 100*$2}' <<< "$VOLUME_DATA")"
      if grep -q '\[MUTED\]' <<< "$VOLUME_DATA"; then
        exec ${dunstify} -u low -t 1000 -i audio-volume-muted \
          -h "string:x-dunst-stack-tag:${volumeTag}" \
          -h "int:value:$VOLUME" \
          "Volume: $VOLUME%" "(muted)"
      else
        if (( "$VOLUME" >= 75 )); then
          ICON=high
        elif (( "$VOLUME" <= 25 )); then
          ICON=low
        else
          ICON=medium
        fi
        exec ${dunstify} -u low -t 1000 -i "audio-volume-$ICON" \
          -h "string:x-dunst-stack-tag:${volumeTag}" \
          -h "int:value:$VOLUME" \
          "Volume: $VOLUME%"
      fi
    '';
    dunstBrightness = let
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    in pkgs.writeShellScriptBin "dunst-brightness" ''
      ${brightnessctl} set "$1"
      BRIGHTNESS="$(awk -F , '{print 100*$3/$5}' <<< "$(${brightnessctl} info -m)")"
      exec ${dunstify} -u low -t 1000 \
        -h "string:x-dunst-stack-tag:${brightnessTag}" \
        -h "int:value:$BRIGHTNESS" \
        "Brightness: $BRIGHTNESS%"
    '';
  in {
    home.packages = [
      dunstVolume
      dunstBrightness
    ];
    services.dunst = {
      enable = true;
      iconTheme = {
        package = self.packages.${pkgs.system}.catppuccin-papirus-folders;
        name = "Papirus-Dark";
        size = "24x24";
      };
      settings = with theme; {
        global = {
          background = "#${base}";
          foreground = "#${text}";
          highlight = "#${teal}";
          frame_color = "#${teal}";
          separator_color = "frame";
          corner_radius = 10;
          offset = "10x50";
          font = "Inter 11";
          dmenu = let
            anyrun = "${config.programs.anyrun.package}/bin/anyrun";
            libstdin = "${inputs.anyrun.packages.${pkgs.system}.stdin}/lib/libstdin.so";
          in "${anyrun} --plugins ${libstdin}";
          browser = "${pkgs.xdg-utils}/bin/xdg-open";
        };
        volume_tag = {
          stack_tag = "${volumeTag}";
          history_ignore = true;
        };
        brightness_tag = {
          stack_tag = "${brightnessTag}";
          history_ignore = true;
        };
        urgency_critical.frame_color = "#${peach}";
      };
    };
  });
}
