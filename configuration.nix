{
  imports =
    [
      ./hub.nix
      ./system/audio.nix
      ./system/boot.nix
      ./system/dconf.nix
      ./system/fonts.nix
      ./system/hardware-configuration.nix
      ./system/host.nix
      ./system/users.nix
      ./system/xdg.nix
    ];

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  system.stateVersion = "26.05";
}
