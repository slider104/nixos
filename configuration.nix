{ pkgs, ... }:
{
  imports =
    [
      ./hub.nix
    ];
  security.sudo.wheelNeedsPassword = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;
  # boot.loader.grub = {
  #   enable = true;
  #   device = "/dev/vda";
  #   useOSProber = false;
  # };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    # "vt.global_cursor_default=0"  # Hide TTY cursor
    # "plymouth.enable=0"           # Disable Plymouth splash (often causes double cursor in VMs)
    "loglevel=3"                  # Reduce boot noise
    "amd_pstate=active"
    "fs.inotify.max_user_watches=524288"
    "snd_hda_intel.dmic_detect=0"
    "usbcore.autosuspend=-1"
  ];
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/0574158e-46bd-43a8-bd49-8e75304ce6f3";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.device-timeout=0"
      "x-systemd.automount"
    ];
  };
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  networking.hostName = "nixos";
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";
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
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config = {
      common.default = "wlr";
    };
  };
  # services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.xserver.enable = false;
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  console.keyMap = "de";
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
  users = {
    users."slider" = {
      isNormalUser = true;
      description = "slider";
      extraGroups = [
        "audio"
        "git"
        "input"
        "networkmanager"
        "video"
        "wheel"
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;
  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    font-awesome
  ];
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  system.stateVersion = "26.05";
}
