{ pkgs, config, lib, ... }:

let
  cfg = config.my.graphical.qutebrowser;
in {
  options.my.graphical.qutebrowser = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable (let
    mapLeader = "<Space>";
  in {
    programs.qutebrowser = {
      enable = true;
      package = (pkgs.qutebrowser.override {enableWideVine = true;}).overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs or [] ++ [ pkgs.makeWrapper ];
        postInstall = old.postInstall or "" + ''
          wrapProgram $out/bin/qutebrowser \
            --unset QT_QPA_PLATFORMTHEME
        '';
      });
      aliases = {
        bN = "tab-prev";
        bd = "tab-close";
        bn = "tab-next";
        bp = "tab-prev";
        h = "help";
        q = "close";
        qa = "quit";
        w = "session-save";
        wq = "quit --save";
        wqa = "quit --save";
        so = "config-source";
        "so%" = "config-source";
      };
      keyBindings = {
        normal = {
          "clc" = "set-cmd-text :open -t https://www.dl.cambridgescp.com/stage/clc/";
          "<Ctrl+Shift+Tab>" = "tab-focus last";
          "<Ctrl+Shift+Space>" = "edit-text";
          "<Ctrl+d>" = "fake-key <PgDown>";
          "<Ctrl+u>" = "fake-key <PgUp>";
          "${mapLeader}<Space>" = ''
            config-cycle statusbar.show in-mode always ;; \
            config-cycle tabs.show switching always \
          '';
        };
        insert = {
          "<Ctrl+Shift+Space>" = "edit-text";
          "<Ctrl+h>" = "fake-key <Backspace>";
          "<Ctrl+w>" = "fake-key <Ctrl+Backspace>";
        };
        command."<Ctrl+w>" = "rl-backward-kill-word";
        prompt."<Ctrl+w>" = "rl-backward-kill-word";
      };
      settings = {
        changelog_after_upgrade = "patch";
        auto_save = {
          session = true;
          interval = 15000;
        };
        editor = {
          command = [
            "/bin/sh" "-c"
            ''
              emacsclient -e '(require '\"'\"'emacs-everywhere nil :noerror)' && \
                emacsclient -c '+{line}:{column}' '{file}' \
            ''
          ];
          remove_file = true;
        };
        content.pdfjs = true;
        scrolling.smooth = true;
        colors.webpage.preferred_color_scheme = "dark";
      };
      extraConfig = ''
        import catppuccin
        catppuccin.setup(c, 'mocha')
        config.unbind('<Ctrl+w>')
        config.unbind('<Ctrl+Shift+w>')
      '';
    };
    xdg.configFile."qutebrowser/catppuccin".source = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "qutebrowser";
      rev = "6737f1c36a9d05be05b7961945e7028c0f70831f";
      sha256 = "0nv214p0k292y2gr5afcjvxnjs1ai78vnxyb7qzj1r4vk7r3nh0k";
    };
  });
}
