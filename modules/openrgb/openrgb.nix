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
      mode = "0755";
    }
    {
      source = "${dotfilesDir}/openrgb/cyan.json";
      target = "cyan.json";
      mode = "0755";
    }
  ];

  # User info
  username = "slider";
  userGroup = "i2c";
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
      mkdir -p ${userHome}/${configDir}/logs
      mkdir -p ${userHome}/${configDir}/plugins
      ${lib.concatMapStrings (file: ''
        cp ${file.source} ${userHome}/${configDir}/${file.target}
        chmod ${file.mode} ${userHome}/${configDir}/${file.target}
        chown ${username}:${userGroup} ${userHome}/${configDir}/${file.target}
        chown ${username}:${userGroup} ${userHome}/${configDir}/logs
        chown ${username}:${userGroup} ${userHome}/${configDir}/plugins
      '') dotfiles}
    '';

    services.hardware.openrgb = {
      enable = true;
    };

    hardware.i2c = {
      enable = true;
      group = "i2c";
    };

    systemd.services.openrgb-load-profile = {
      description = "Load OpenRGB profiles on startup";
      after = [ "openrgb.service" "hardware.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "slider";
        ExecStart = "${pkgs.openrgb}/bin/openrgb --config ${userHome}/${configDir}/cyan.json";
      };
    };
    services.udev.rules = [
      ''KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"''
    ];
  };
}
