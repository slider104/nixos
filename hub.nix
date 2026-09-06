{ config, pkgs, ... }:
{
  imports = [
    ./modules/alacritty/alacritty.nix
    ./modules/bash/bash.nix
    ./modules/fuzzel/fuzzel.nix
    ./modules/gaming/gaming.nix
    ./modules/git/git.nix
    ./modules/ly/ly-niri.nix
    ./modules/mako/mako.nix
    ./modules/nemo/nemo.nix
    ./modules/niri/niri.nix
    ./modules/openrgb/openrgb.nix
    ./modules/virt/virt.nix
    ./modules/waybar/waybar.nix
    ./modules/wofi/wofi.nix
    ./modules/zed/zed-editor.nix
    ./my-pkgs.nix
  ];

  # --- ENABLE MODULES ---
  alacritty.enable    = true;
  bash.enable         = true;
  fuzzel.enable       = true;
  gaming.enable       = true;
  git.enable          = true;
  ly-niri.enable      = true;
  mako.enable         = true;
  my-pkgs.enable      = true;
  nemo.enable         = true;
  niri.enable         = true;
  openrgb.enable      = true;
  virt.enable         = true;
  waybar.enable       = true;
  wofi.enable         = false;
  zed-editor.enable   = true;

  # --- MERGE BLOCK ---
  environment.systemPackages = pkgs.lib.mkMerge [
    config.alacritty.packages
    config.bash.packages
    config.fuzzel.packages
    config.gaming.packages
    config.git.packages
    config.ly-niri.packages
    config.mako.packages
    config.my-pkgs.packages
    config.nemo.packages
    config.niri.packages
    config.openrgb.packages
    config.virt.packages
    config.waybar.packages
    config.wofi.packages
    config.zed-editor.packages
  ];
}
