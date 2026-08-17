{ config, pkgs, lib, ... }:

let
  myModuleName = "niri";
  myModulePackages = [
    pkgs.alacritty
    pkgs.brave
    pkgs.capitaine-cursors
    pkgs.nemo
    pkgs.nemo-fileroller
    pkgs.niri
    pkgs.swaybg
    pkgs.xwayland-satellite
  ];

  # Dotfiles configuration
  dotfilesDir = "/home/slider/nixos/dotfiles";
  configDir = ".config/niri";

  dotfiles = [
    {
      source = "${dotfilesDir}/niri/config.kdl";
      target = "config.kdl";
      mode = "0644";
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
      preStart = "${pkgs.bash}/bin/bash -c 'until [ -e /dev/dri/renderD128 ]; do sleep 0.1; done'";
    #   wants = [ "display-manager.service" ];
    #   serviceConfig = {
    #     Type = "simple";
    #     User = "${username}";
    #     Group = "video";
    #     SupplementaryGroups = [ "video" "render" ];
    #     ExecStart = "${pkgs.niri}/bin/niri";
    #     Restart = "on-failure";
    #     RestartSec = 5;
    #     Environment = [
    #       "XDG_RUNTIME_DIR=/run/user/1000"
    #       "PATH=/run/current-system/sw/bin"
    #     ];
    #     StandardInput = "tty";
    #     StandardOutput = "journal";
    #     StandardError = "journal";
    #     # Ensure niri can access devices
    #     PrivateDevices = false;
    #     DevicePolicy = "auto";
    #   };
    };
  };
}
