{ config, pkgs, lib, ... }:

let
  myModuleName = "niri";
  myModulePackages = [
    pkgs.brave
    pkgs.capitaine-cursors
    pkgs.niri
    pkgs.swaybg
    pkgs.xwayland-satellite
  ];

  dotfilesDir = "/home/slider/nixos/dotfiles";
  configDir = ".config/niri";

  dotfiles = [
    {
      source = "${dotfilesDir}/niri/config.kdl";
      target = "config.kdl";
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
    programs.${myModuleName} = {
      enable = true;
    };

    systemd.user.services.${myModuleName} = {
    #   enable = true;
      after = [
        "graphical-session-pre.target"
    #     "display-manager.service"
    #     "systemd-user-sessions.service"
    #     "sound.target"
      ];
      preStart = "${pkgs.bash}/bin/bash -c 'until [ -e /dev/dri/renderD128 ]; do sleep 0.5; done'";
    };
  };
}
