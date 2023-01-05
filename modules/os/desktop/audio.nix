{ config, lib, ... }:

let
  cfg = config.my.desktop.audio;
in {
  options.my.desktop.audio = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
    };
  };
}
