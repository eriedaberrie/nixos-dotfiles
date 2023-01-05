{ pkgs, config, lib, ... }:

let
  systemConfigDirectory = "${config.xdg.configHome}/nixos";
  npmPackagesPath = "${config.home.homeDirectory}/.npm-packages";
in {
  home = {
    shellAliases = {
      lg = "lazygit";
      e = "emacsclient -n -c -a ''";
      et = "emacsclient -nw -a ''";
      v = "nvim";
      n = "neovide --nofork";
      java = "java -Dawt.useSystemAAFontSettings=lcd";
      j = "javac *.java && java Main";
      syu = "nix flake update --commit-lock-file ${systemConfigDirectory}";
      nswitch = "sudo nixos-rebuild switch --flake ${systemConfigDirectory}";
    };
    file.".npmrc".text = ''
      prefix = ${npmPackagesPath}
    '';
    sessionPath = [
      "${npmPackagesPath}/bin"
    ];
    sessionVariables.NODE_PATH = "${npmPackagesPath}/lib/node_modules";
  };
  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      autocd = true;
      localVariables = {
        ZVM_VI_HIGHLIGHT_FOREGROUND = "black";
        ZVM_VI_HIGHLIGHT_BACKGROUND = "red";
      };
      initExtraFirst = ''
        if [[ -n $INSIDE_EMACS ]]; then
          bindkey -e
        else
          AUTOPAIR_INHIBIT_INIT=true
        fi
      '';
      initExtra = ''
        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list ''\'' \
          'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
          '+r:|[._-]=* r:|=*' \
          '+l:|=* r:|=*'
        zmodload zsh/complist
        bindkey -M menuselect "''${terminfo[kcbt]}" reverse-menu-complete
        if [[ -n $INSIDE_EMACS ]]; then
          autoload -Uz add-zsh-hook
          add-zsh-hook -d precmd zvm_init
          bindkey "^W" vi-backward-kill-word
        else
          zle -N autopair-insert
          zle -N autopair-close
          zle -N autopair-delete

          zvm_after_init_commands+=('
            for p in ''${(@k)AUTOPAIR_PAIRS}; do
              zvm_bindkey viins "$p" autopair-insert
              bindkey -M isearch "$p" self-insert

              local rchar="$(_ap-get-pair $p)"
              if [[ $p != $rchar ]]; then
                  zvm_bindkey viins "$rchar" autopair-close
                  bindkey -M isearch "$rchar" self-insert
              fi
            done

            zvm_bindkey viins "''${terminfo[kbs]}" autopair-delete
            zvm_bindkey viins "^h" autopair-delete
            bindkey -M isearch "''${terminfo[kbs]}" backward-delete-char
            bindkey -M isearch "^h" backward-delete-char
            zvm_bindkey viins "^[''${terminfo[kbs]}" vi-backward-kill-word
            zvm_bindkey viins "^W" vi-backward-kill-word
          ')
        fi
      '';
      plugins = with pkgs; [
        {
          name = "zsh-autopair";
          src = zsh-autopair;
          file = "share/zsh/zsh-autopair/autopair.zsh";
        }
        {
          name = "zsh-vi-mode";
          src = zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
        {
          name = "fast-syntax-highlighting";
          src = zsh-fast-syntax-highlighting;
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        }
      ];
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        continuation_prompt = "[>](bold green) ";
        character = {
          disabled = false;
          success_symbol = "[%](bold green)";
          error_symbol = "[%](bold yellow)";
          vimcmd_symbol = "[%](bold blue)";
        };
        status = {
          disabled = false;
          format = "[$symbol$common_meaning$status]($style) ";
          symbol = "";
          map_symbol = true;
          not_executable_symbol = "+x ";
          not_found_symbol = "?? ";
          sigint_symbol = "XX ";
          signal_symbol = "!! ";
          pipestatus = true;
          pipestatus_separator = "[|](bold yellow) ";
          pipestatus_format = "[\\[](bold yellow) $pipestatus"
                              + "[\\] => ](bold yellow)"
                              + "[$symbol$common_meaning$status]($style) ";
        };
        directory = {
          style = "bold blue";
          truncation_length = 6;
          truncate_to_repo = false;
          truncation_symbol = ".../";
        };
        git_branch.format = "[$symbol$branch(:$remote_branch)]($style) ";
        line_break.disabled = true;
        c.disabled = true;
        cmake.disabled = true;
        golang.disabled = true;
        haskell.disabled = true;
        java.disabled = false; # the only marginally useful one
        nodejs.disabled = true;
        lua.disabled = true;
        package.disabled = true;
        perl.disabled = true;
        python.disabled = true;
        ruby.disabled = true;
        rust.disabled = true;
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
