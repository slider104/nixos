{ pkgs, ... }:
{
  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
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
  services.xserver.displayManager.sessionPackages = [ pkgs.polkit_gnome ];

  services.gvfs.enable = true;

  nixpkgs.config.allowUnfree = true;
}
