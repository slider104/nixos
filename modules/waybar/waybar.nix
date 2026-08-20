{ config, pkgs, lib, ... }:

let
  myModuleName = "waybar";
  myModulePackages = [
    pkgs.brightnessctl
    pkgs.pavucontrol
    pkgs.lm_sensors
    pkgs.waybar
  ];

  dotfilesDir = "/home/slider/nixos/dotfiles";
  configDir = ".config/waybar";

  dotfiles = [
    {
      source = "${dotfilesDir}/waybar/config";
      target = "config";
      mode = "0644";
    }
    {
      source = "${dotfilesDir}/waybar/style.css";
      target = "style.css";
      mode = "0644";
    }
    {
      source = "${dotfilesDir}/waybar/power-menu.sh";
      target = "power-menu.sh";
      mode = "0755";
    }
    {
      source = "${dotfilesDir}/waybar/start-waybar.sh";
      target = "start-waybar.sh";
      mode = "0755";
    }

  ];

  username = "slider";
  userGroup = "users";
  userHome = "/home/${username}";

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

    system.activationScripts."${myModuleName}-dotfiles" = ''
      mkdir -p ${userHome}/${configDir}
      ${lib.concatMapStrings (file: ''
        cp ${file.source} ${userHome}/${configDir}/${file.target}
        chmod ${file.mode} ${userHome}/${configDir}/${file.target}
        chown ${username}:${userGroup} ${userHome}/${configDir}/${file.target}
      '') dotfiles}
    '';
  };
}
