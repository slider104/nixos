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
  ];

  username = config.users.users.slider.name;
  userGroup = config.users.users.slider.group;
  userHome = config.users.users.slider.home;

  rules = lib.map (file: [
    "d ${userHome}/${myConfigDir} 0755 ${username} ${userGroup} -"
    "L+ ${userHome}/${myConfigDir}/${file.target} 0755 ${username} ${userGroup} ${file.source}"
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

    systemd.user.services.waybar = {
      serviceConfig = {
        execStart = "${pkgs.waybar}/bin/waybar -c ${userHome}/${myConfigDir}/config -s ${userHome}/${myConfigDir}/style.css";
      };
    };
  };
}
