{ config, pkgs, lib, ... }:

let
  myModuleName = "fuzzel";
  myModulePackages = [
    pkgs.fuzzel
  ];

  myConfigDir = ".config/fuzzel";
  myConfigFiles = [
    { source = ../../dotfiles/fuzzel/fuzzel.ini; target = "fuzzel.ini"; perms = "0777";}
  ];

  username = config.users.users.slider.name;
  userGroup = config.users.users.slider.group;
  userHome = config.users.users.slider.home;

  rules = lib.map (file: [
    "d ${userHome}/${myConfigDir} 0777 ${username} ${userGroup} -"
    "C+ ${userHome}/${myConfigDir}/${file.target} ${file.perms} ${username} ${userGroup} ${file.source}"
  ]) myConfigFiles;

  flatRules = lib.flatten rules;
in
{
  options.${myModuleName} = {
    enable = lib.mkEnableOption "${myModuleName}";
    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };
  };

  config = lib.mkIf config.${myModuleName}.enable {
    ${myModuleName}.packages = myModulePackages;
    systemd.tmpfiles.rules = flatRules;
  };
}
