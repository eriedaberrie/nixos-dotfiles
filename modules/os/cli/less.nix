{ config, lib, ... }:

let
  cfg = config.my.cli.less;
in {
  options.my.cli.less = {
    enable = lib.mkEnableOption null // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.less.enable = true;
    environment.sessionVariables = {
      MANPAGER = "less -R --use-color -Dd+r -Du+b";
      MANROFFOPT = "-P -c";
    };
  };
}
