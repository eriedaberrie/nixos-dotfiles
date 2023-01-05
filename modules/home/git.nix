{ pkgs, config, lib, ... }:

let
  cfg = config.my.git;
in {
  options.my.git = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.FILTER_BRANCH_SQUELCH_WARNING = 1;
    programs.git = {
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
  };
}
