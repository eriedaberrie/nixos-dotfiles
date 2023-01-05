{ self, pkgs, inputs, config, ... }:

let
  username = "errie";
  homeDirectory = "/home/${username}";
in {
  imports = [
    # inputs.nur.hmModules.nur
    ./themes
    ./wayland
    ./packages.nix
    ./shell.nix
    ./emacs.nix
    ./dunst.nix
    ./mpv.nix
    ./spotify.nix
    ./firefox.nix
    ./qutebrowser.nix
    ./fetch.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "22.11";

    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = 1;
    };

    pointerCursor = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "Catppuccin-Mocha-Dark-Cursors";
      size = 24;
      gtk.enable = true;
    };
  };

  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
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
        "text/html" = browser;
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
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    configFile = {
      "ranger/rc.conf".text = ''
        set preview_images true
        set preview_images_method kitty
      '';
      "btop/themes/catppuccin_mocha.theme".source = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "btop";
        rev = "ecb8562bb6181bb9f2285c360bbafeb383249ec3";
        sha256 = "0sfyf44lwmf4mkd4gjkw82wn7va56c8xy06cx4q6b3drjfx6vxd2";
      } + "/catppuccin_mocha.theme";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  services = {
    mpris-proxy.enable = true;
    gammastep = {
      enable = true;
      provider = "geoclue2";
      temperature = {
        day = 6500;
        night = 2750;
      };
      settings = {
        general = {
          fade = 1;
          adjustment-method = "wayland";
        };
      };
    };
  };

  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
      userName = "eriedaberrie";
      userEmail = "eriedaberrie@gmail.com";
      aliases = {
        hardfetch = "!git fetch --progress $1 && git reset --hard $1 && :";
        syncdates = "filter-branch --env-filter 'export GIT_COMMITTER_DATE=\"$GIT_AUTHOR_DATE\"'";
      };
      extraConfig = {
        commit.verbose = true;
        pull.rebase = true;
        push.autoSetupRemote = true;
        rebase.autoStash = true;
        github.user = "eriedaberrie";
        gitlab.user = "eriedaberrie";
      };
    };
    exa = {
      enable = true;
      enableAliases = true;
    };
    bat = {
      enable = true;
      config = {
        map-syntax = [ "flake.lock:JSON" ];
        theme = "catppuccinMocha";
      };
      themes = {
        catppuccinMocha = builtins.readFile (pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "1g2r6j33f4zys853i1c5gnwcdbwb6xv5w6pazfdslxf69904lrg9";
        } + "/Catppuccin-mocha.tmTheme");
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [ packer-nvim ];
    };
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
        color_theme = "catppuccin_mocha";
      };
    };
    kitty = {
      enable = true;
      theme = "Catppuccin-Mocha";
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 10.5;
      };
      keybindings = {
        "ctrl+backspace" = "send_text all \\x1b\\x7f";
      };
      settings = {
        window_margin_width = 5;
        background_opacity = "0.88";
        focus_follows_mouse = "yes";
      };
    };
    zathura = {
      enable = true;
      extraConfig = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "zathura";
        rev = "d85d8750acd0b0247aa10e0653998180391110a4";
        sha256 = "1hv9wzjyg34533qaxc5dc3gy8fcyvpvzcri2aip1kf4varnpcn75";
      } + "/src/catppuccin-mocha");
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
    };
    java.enable = true;
  };
}
