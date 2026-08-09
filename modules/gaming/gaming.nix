{ pkgs, ... }:

{
  imports = [
  ];

  environment.systemPackages = [
    # Primary Launchers
    pkgs.steam
    pkgs.prismlauncher        # Minecraft (managed modpacks)
    # pkgs.heroic               # Epic Games & GOG
    # pkgs.lutris               # Universal launcher for non-store games
    pkgs.protonup-qt          # GUI to install Proton-GE & Luxtorpeda

    # Utilities
    pkgs.mangohud             # FPS/Performance overlay (Shift+R+F12)
    pkgs.gamescope            # Compositor (also available system-wide)
    pkgs.gamemode             # Client binary
    pkgs.winetricks           # Wine configuration helper

    # Emulation (Optional)
    # pkgs.retroarch
    # pkgs.rpcs3
    # pkgs.yuzu
  ];

  # Kernel Optimization (Optional)
  # boot.kernelPackages = pkgs.linuxPackages_xanmod;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ]; # Auto-install Proton GE

    # Enable Gamescope session support (Steam Deck like experience)
    gamescopeSession.enable = false;

    # Optional: Enable Platform Optimizations (sysctl tweaks from SteamOS)
    # platformOptimizations.enable = true;
  };

  # Performance Tools
  # Gamemode: Automatically boosts CPU/GPU priority when games run
  programs.gamemode = {
    enable = true;
    enableRenice = true; # Give games higher priority
  };

  # Gamescope: Micro-compositor for scaling, FSR, and frame limiting
  programs.gamescope = {
    enable = true;
    capSysNice = true; # Allow real-time scheduling
    args = [
      "--rt"             # Real-time priority
      "--expose-wayland" # Native Wayland support
    ];
  };
}
