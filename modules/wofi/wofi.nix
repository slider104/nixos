{ config, pkgs, lib, ... }:

let
  myModuleName = "wofi";
  myModulePackages = [
    pkgs.wofi
    pkgs.wofi-emoji
    pkgs.wofi-power-menu
  ];

  dotfilesDir = "/home/slider/nixos/dotfiles";
  configDir = ".config/wofi";

  dotfiles = [
    {
      source = "${dotfilesDir}/wofi/config";
      target = "config";
      mode = "0644";
    }
    {
      source = "${dotfilesDir}/wofi/style.css";
      target = "style.css";
      mode = "0644";
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
