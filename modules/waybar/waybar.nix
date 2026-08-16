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
    { source = ../../dotfiles/waybar/config; target = "config"; }
    { source = ../../dotfiles/waybar/style.css; target = "style.css"; }
    { source = ../../dotfiles/waybar/scripts/power-menu.sh; target = "scripts/power-menu.sh"; }
  ];

  username = config.users.users.slider.name;
  userGroup = config.users.users.slider.group;
  userHome = config.users.users.slider.home;

  rules = lib.map (file: [
    "d ${userHome}/${myConfigDir} 0755 ${username} ${userGroup} -"
    "L+ ${userHome}/${myConfigDir}/${file.target} 0755 ${file.source}"
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
