{ pkgs, config, lib, ... }:

let
  cfg = config.my.interception;
in {
  options.my.interception = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    # Swap caps lock and escape, CTRL -> BS on press
    services.interception-tools = {
      enable = true;
      plugins = with pkgs.interception-tools-plugins; [ caps2esc dual-function-keys ];
      udevmonConfig = let
        inherit (pkgs.interception-tools-plugins) caps2esc dual-function-keys;
        _ = x: "${pkgs.interception-tools}/bin/${x}";
        dffConf = pkgs.writeText "dual-function-keys.yaml" ''
          TIMING:
            TAP_MILLISEC: 125
            DOUBLE_TAP_MILLISEC: 0
          MAPPINGS:
            - KEY: KEY_LEFTSHIFT
              TAP: KEY_KPLEFTPAREN
              HOLD: KEY_LEFTSHIFT
            - KEY: KEY_RIGHTSHIFT
              TAP: KEY_KPRIGHTPAREN
              HOLD: KEY_RIGHTSHIFT
            - KEY: KEY_LEFTALT
              TAP: [KEY_LEFTCTRL, KEY_BACKSPACE]
              HOLD: KEY_LEFTALT
        '';
      in ''
        - JOB: "${_ "intercept"} -g $DEVNODE | ${dual-function-keys}/bin/dual-function-keys -c ${dffConf} | ${caps2esc}/bin/caps2esc | ${_ "uinput"} -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK, KEY_ESC, KEY_LEFTSHIFT, KEY_LEFTALT]
      '';
    };
  };
}
