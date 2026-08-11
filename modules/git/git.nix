{ config, pkgs, lib, ... }:

let
  myModuleName = "git";
  myModulePackages = with pkgs; [
    git
  ];
in
{
  options.${myModuleName}.enable = lib.mkEnableOption "${myModuleName}";
  options.${myModuleName}.packages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [];
  };

  config = lib.mkIf config.${myModuleName}.enable {
    ${myModuleName}.packages = myModulePackages;

    programs.git = {
      enable = true;
      config = {
        user.name = "slider";
        user.email = "matze33442@gmx.de";
        github.user = "slider104";
        core.editor = "fresh";
        init.defaultBranch = "main";
        pull.rebase = false;
        fetch.prune = true;
        alias = {
          st = "status";
          ck = "checkout";
          br = "branch";
          cm = "commit";
          ps = "push";
          pl = "pull";
          ad = "add";
          unstage = "reset HEAD --";
        };
      };
    };
  };
}
