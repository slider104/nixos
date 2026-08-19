{ config, pkgs, lib, ... }:

let
  myModuleName = "openrgb";
  myModulePackages = [
    pkgs.openrgb
  ];

  dotfilesDir = "/home/slider/nixos/dotfiles";
  configDir = ".config/OpenRGB";

  dotfiles = [
    {
      source = "${dotfilesDir}/openrgb/settings.json";
      target = "settings.json";
      mode = "0644";
    }
    {
      source = "${dotfilesDir}/openrgb/profiles";
      target = "profiles";
      mode = "0755";
    }
  ];

  # User info
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

    services.hardware.openrgb = {
      enable = true;
    };

    hardware.i2c = {
      enable = true;
      group = "i2c";
    };
  };
}
