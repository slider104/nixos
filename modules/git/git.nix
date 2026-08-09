{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.git
  ];
  programs.git = {
    enable = true;
    config = {
      user.name = "slider";
      user.email = "matze33442@gmx.de";
      github.user = "slider104";
      core.editor = "fresh-editor";
      init.defaultBranch = "main";
      pull.rebase = false;
      fetch.prune = true;
      alias = {
        gst = "status";
        gck = "checkout";
        gbr = "branch";
        gcm = "commit";
        gps = "push";
        gpl = "pull";
        gad = "add";
        unstage = "reset HEAD --";
      };
    };
  };
}
