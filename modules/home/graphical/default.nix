{ pkgs, config, lib, ... }:

let
  cfg = config.my.graphical;
in {
  imports = [
    ./wayland
    ./dunst.nix
    ./emacs.nix
    ./firefox.nix
    ./kitty.nix
    ./mpv.nix
    ./obs.nix
    ./qtk.nix
    ./qutebrowser.nix
    ./zathura.nix
  ];

  options.my.graphical = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
      };
      mimeApps = {
        enable = true;
        defaultApplications = let
          editor = "emacsclient.desktop";
          email = "emacsclient-mail.desktop";
          pdf = "org.pwmt.zathura.desktop";
          browser = "firefox.dekstop";
          image = "imv.desktop";
          video = "mpv.desktop";
        in {
          "application/octet-stream" = editor;
          "text/plain" = editor;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/mailto" = email;
          "application/pdf" = pdf;
          "image/bmp" = image;
          "image/jpeg" = image;
          "image/gif" = image;
          "image/png" = image;
          "image/svg+xml" = image;
          "image/webp" = image;
          "video/mp4" = video;
          "video/mpeg" = video;
        };
      };
    };

    services = {
      mpris-proxy.enable = true;
      blueman-applet.enable = true;
      network-manager-applet.enable = true;
    };

    home = {
      pointerCursor = {
        package = pkgs.catppuccin-cursors.mochaDark;
        name = "Catppuccin-Mocha-Dark-Cursors";
        size = 24;
        gtk.enable = true;
      };
    };
  };
}
