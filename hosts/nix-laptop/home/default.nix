_:

{
  imports = [ ./packages.nix ];

  my = {
    email.enable = true;
    git.enable = true;

    cli = {
      bat.enable = true;
      btop.enable = true;
      exa.enable = true;
      neovim.enable = true;
      ranger.enable = true;
    };

    fetch = {
      fastfetch.enable = true;
      neofetch.enable = true;
      others.enable = true;
    };

    graphical = {
      enable = true;
      dunst.enable = true;
      emacs.enable = true;
      firefox.enable = true;
      mpv.enable = true;
      obs.enable = true;
      qutebrowser.enable = true;
      zathura.enable = true;

      wayland = {
        enable = true;
        anyrun.enable = true;
        hyprland.enable = true;
        eww.enable = true;
        foot.enable = true;
        gammastep.enable = true;
        swayidle.enable = true;
        swaylock.enable = true;
        ydotool.enable = true;
      };
    };

    shell = {
      aliases.enable = true;
      direnv.enable = true;
      fish.enable = true;
      globalNpmPackages.enable = true;
      starship.enable = true;
      zsh.enable = true;
    };

    spotify = {
      spicetify.enable = true;
      spotifyd.enable = true;
    };
  };

  programs.java.enable = true;

  home.stateVersion = "22.11";
}
