{ pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/gaming/gaming.nix
      ./modules/git/git.nix
      ./modules/ly/ly-niri.nix
    ];

  # Bootloader
  boot.loader.timeout = 1;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    useOSProber = false;
  };

  security.sudo.wheelNeedsPassword = false;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "vt.global_cursor_default=0"  # Hide TTY cursor
    "plymouth.enable=0"           # Disable Plymouth splash (often causes double cursor in VMs)
    "loglevel=3"                  # Reduce boot noise
    "amd_pstate=active"
    "fs.inotify.max_user_watches=524288"
  ];

  networking.hostName = "nixos";
  # networking.wireless.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # Time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Desktop Portal for Dialogs
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = "gtk";
    };
  };

  services.gvfs.enable = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."slider" = {
    isNormalUser = true;
    description = "slider";
    extraGroups = [ "audio" "git" "input" "networkmanager" "video" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  # $ nix search wget
  environment.systemPackages = [
    pkgs.bat
    pkgs.bottom
    pkgs.fresh-editor
    pkgs.git
    pkgs.nil
    pkgs.seahorse
    pkgs.shortwave
    pkgs.superfile
    pkgs.vulkan-tools
    pkgs.wget
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    font-awesome
  ];

  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  system.stateVersion = "26.05";

}
