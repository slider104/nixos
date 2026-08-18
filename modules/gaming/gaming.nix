{ config, pkgs, lib, ... }:

let
  myModuleName = "gaming";
  myModulePackages = [
    # Primary Launchers
    pkgs.steam
    pkgs.prismlauncher
    # pkgs.heroic
    # pkgs.lutris

    # Utilities
    pkgs.gamescope
    pkgs.gamemode
    pkgs.mangohud
    pkgs.protonup-qt
    pkgs.winetricks

    # Emulation
    # pkgs.retroarch
    # pkgs.rpcs3
    # pkgs.yuzu
  ];
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

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      gamescopeSession.enable = false; # Steam Deck session
    };

    programs.gamemode = {
      enable = true;
      enableRenice = true;
    };

    programs.gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };

    # Optional: Kernel Optimizations
    # boot.kernelPackages = pkgs.linuxPackages_xanmod;
  };
}
