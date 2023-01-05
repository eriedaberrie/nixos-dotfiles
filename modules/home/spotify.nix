{ pkgs, inputs, config, lib, osConfig, ... }:

let
  cfg = config.my.spotify;
in {
  imports = [ inputs.spicetify-nix.homeManagerModule ];

  options.my.spotify = {
    spicetify.enable = lib.mkEnableOption null;
    spotifyd.enable = lib.mkEnableOption null;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.spicetify.enable {
      home.packages = [
        (pkgs.runCommandLocal "spicetify-desktop" { } ''
          mkdir -p "$out/share/applications"
          ${pkgs.ed}/bin/ed ${pkgs.spotify}/share/applications/spotify.desktop <<- EOF
            %s/^Exec=spotify/Exec=spotifywm/
            w $out/share/applications/spotify.desktop
          EOF
        '')
      ];

      programs.spicetify = let
        spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
      in {
        enable = true;
        theme = spicePkgs.themes.catppuccin-mocha;
        colorScheme = "teal";
        windowManagerPatch = true;
        enabledExtensions = with spicePkgs.extensions; [
          fullAppDisplay
          shuffle
        ];
      };
    })

    (lib.mkIf cfg.spotifyd.enable {
      home.packages = [ pkgs.spotify-tui ];

      services.spotifyd = {
        enable = true;
        package = pkgs.spotifyd.override {
          withMpris = true;
          withPulseAudio = true;
        };
        settings.global = {
          username_cmd = "head -1 ${osConfig.age.secrets.spotify.path}";
          password_cmd = "tail -1 ${osConfig.age.secrets.spotify.path}";
          device_name = "spotifyd";
          cache_path = "${config.xdg.cacheHome}/spotifyd";
          max_cache_size = 1000000000;
          no_audio_cache = false;
          bitrate = 320;
          initial_volume = "60";
          volume_normalization = true;
          normalisation_pregain = -10;
          use_mpris = true;
          backend = "pulseaudio";
          volume_controller = "softvol";
          zeroconf_port = 1234;
        };
      };

      xdg.configFile."spotify-tui/config.yml".source = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "spotify-tui";
        rev = "45a4ef12508784410c516746c9d84862d52e4567";
        sha256 = "1i9c30n20wq0mpvfd2ip19b1mp9ifiy2shxh16i6kfql9jr7wwj5";
      } + "/mocha.yml";
    })
  ];
}
