{ pkgs, ... }: {
  imports = [ ../niri/niri.nix ];
  programs.niri.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;
  services.displayManager = {
    ly = {
      enable = true;
      settings = {
        animate = true;
        animation = "matrix";
      };
    };
    autoLogin = {
      enable = true;
      user = "slider";
    };
    defaultSession = "niri";
    sessionPackages = [ pkgs.niri ];
  };
  environment.systemPackages = [
    pkgs.cmatrix
    pkgs.polkit_gnome
  ];
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
