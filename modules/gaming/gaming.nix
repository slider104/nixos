{ config, pkgs, lib, ... }:

let
  # --- CONFIGURATION BLOCK ---
  myModuleName = "gaming";

  # Packages to install
  myModulePackages = [
    # Primary Launchers
    pkgs.steam
    pkgs.prismlauncher
    # pkgs.heroic
    # pkgs.lutris
    pkgs.protonup-qt

    # Utilities
    pkgs.mangohud
    pkgs.gamescope
    pkgs.gamemode
    pkgs.winetricks

    # Emulation
    # pkgs.retroarch
    # pkgs.rpcs3
    # pkgs.yuzu
  ];
in
{
  # --- DEFINE OPTIONS ---
  options.${myModuleName}.enable = lib.mkEnableOption "${myModuleName}";
  options.${myModuleName}.packages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [];
  };

  # --- APPLY LOGIC ---
  config = lib.mkIf config.${myModuleName}.enable {

    # Set the packages variable (for the merge in config.nix)
    ${myModuleName}.packages = myModulePackages;

    # Enable System-Wide Graphics
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Enable Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      gamescopeSession.enable = false; # Steam Deck session
    };

    # Enable Gamemode
    programs.gamemode = {
      enable = true;
      enableRenice = true;
    };

    # Enable Gamescope
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
