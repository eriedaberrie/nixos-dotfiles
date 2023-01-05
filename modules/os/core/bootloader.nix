{ config, lib, ... }:

let
  cfg = config.my.bootloader;
in {
  options.my.bootloader = {
    type = lib.mkOption {
      type = with lib.types; nullOr (enum [ "systemdBoot" ]);
      default = null;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.type == "systemdBoot") {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
        timeout = 0;
      };
    })
  ];
}
