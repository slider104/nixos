{ config, pkgs, lib, ... }:

let
  myModuleName = "waybar";
  myModulePackages = [
    pkgs.brightnessctl
    pkgs.gpu-usage-waybar
    pkgs.pavucontrol
    pkgs.lm_sensors
    pkgs.waybar
  ];

  myConfigDir = ".config/waybar";
  myConfigFiles = [
    { source = ../../dotfiles/waybar/config; target = "config"; perms = "0777";}
    { source = ../../dotfiles/waybar/style.css; target = "style.css"; perms = "0777";}
    { source = ../../dotfiles/waybar/power-menu.sh; target = "power-menu.sh"; perms = "0777";}
    { source = ../../dotfiles/waybar/start-waybar.sh; target = "start-waybar.sh"; perms = "0777";}
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
