{ config, pkgs, ... }:
{
  imports = [
    ./modules/bash/bash.nix
    ./modules/fuzzel/fuzzel.nix
    ./modules/gaming/gaming.nix
    ./modules/git/git.nix
    ./modules/ly/ly-niri.nix
    ./modules/niri/niri.nix
    ./modules/openrgb/openrgb.nix
    ./modules/waybar/waybar.nix
    ./modules/wofi/wofi.nix
    ./modules/zed/zed-editor.nix
    ./my-pkgs.nix
  ];

  # --- ENABLE MODULES ---
  bash.enable = true;
  fuzzel.enable = true;
  gaming.enable = true;
  git.enable = true;
  ly-niri.enable = true;
  my-pkgs.enable = true;
  niri.enable = true;
  openrgb.enable = true;
  waybar.enable = true;
  wofi.enable = false;
  zed-editor.enable = true;

  # --- MERGE BLOCK ---
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = pkgs.lib.mkMerge [
    config.bash.packages
    config.fuzzel.packages
    config.gaming.packages
    config.git.packages
    config.ly-niri.packages
    config.my-pkgs.packages
    config.niri.packages
    config.openrgb.packages
    config.waybar.packages
    config.wofi.packages
    config.zed-editor.packages
  ];
}
