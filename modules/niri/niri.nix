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

  myConfigDir = ".config/niri";
  myConfigFiles = [
    { source = ../../dotfiles/niri/config.kdl; target = "config.kdl"; }
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

    programs.${myModuleName} = {
      enable = true;
      settings = {
        spawn-at-startup = [
          { command = [ "${pkgs.waybar}/bin/waybar" "-c" "${userHome}/${myConfigDir}/config" "-s" "${userHome}/${myConfigDir}/style.css" ]; }
        ];
      };
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
