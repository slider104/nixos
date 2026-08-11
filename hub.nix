{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/bash/bash.nix
    ./modules/fuzzel/fuzzel.nix
    ./modules/gaming/gaming.nix
    ./modules/git/git.nix
    ./modules/ly/ly-niri.nix
    ./modules/niri/niri.nix
    ./modules/waybar/waybar.nix
    ./modules/wofi/wofi.nix
    ./modules/zed/zed.nix
  ];

  # --- ENABLE MODULES ---
  bash.enable = true;
  fuzzel.enable = true;
  gaming.enable = true;
  git.enable = true;
  ly-niri.enable = true;
  niri.enable = true;
  waybar.enable = true;
  wofi.enable = true;
  zed.enable = true;

  # --- MERGE BLOCK ---
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = pkgs.lib.mkMerge [
    config.bash.packages
    config.fuzzel.packages
    config.gaming.packages
    config.git.packages
    config.ly-niri.packages
    config.niri.packages
    config.waybar.packages
    config.wofi.packages
    config.zed.packages

    pkgs.bat
    pkgs.bottom
    pkgs.fresh-editor
    pkgs.nil
    pkgs.seahorse
    pkgs.shortwave
    pkgs.superfile
    pkgs.vulkan-tools
    pkgs.wget
  ];
}
