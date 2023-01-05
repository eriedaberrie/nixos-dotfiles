{ inputs, config, ... }:

{
  nixpkgs.overlays = with inputs; [
    (import emacs-overlay)
    hyprland.overlays.default
  ] ++ [(_: prev: {
    stablePkgs = import inputs.nixpkgs-stable {
      inherit (prev) system;
      inherit (config.nixpkgs) config;
    };

    sudo = prev.sudo.override {
      withInsults = true;
    };

    qutebrowser = (prev.qutebrowser.override {
      enableWideVine = true;
    }).overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs or [] ++ [ prev.makeWrapper ];
      postInstall = old.postInstall or "" + ''
        wrapProgram $out/bin/qutebrowser \
          --unset QT_QPA_PLATFORMTHEME
      '';
    });

    spotifyd = prev.spotifyd.override {
      withMpris = true;
      withPulseAudio = true;
    };

    geticons = prev.callPackage ./pkgs/geticons.nix { };
    catppuccin-folders-mocha = prev.callPackage ./pkgs/catppuccin-folders-mocha.nix { };
  })];
}
