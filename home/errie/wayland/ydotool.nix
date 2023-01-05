{ pkgs, ... }:

{
  home.packages = [ pkgs.ydotool ];
  xdg.configFile = let
    serviceName = "ydotool.service";
    service = "${pkgs.ydotool}/share/systemd/user/${serviceName}";
  in {
    "systemd/user/${serviceName}".source = service;
    "systemd/user/default.target.wants/${serviceName}".source = service;
  };
}
