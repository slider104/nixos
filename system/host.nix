{
  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;
  security.polkit.extraRules = ''
  polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.power-off" ||
        action.id == "org.freedesktop.login1.reboot" ||
        action.id == "org.freedesktop.login1.suspend" ||
        action.id == "org.freedesktop.login1.hibernate") {
      if (subject.isInGroup("users") || subject.user == "slider") {
        return polkit.Result.YES;
      }
    }
  });
  '';
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.xserver.enable = false;
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  console.keyMap = "de";
}
