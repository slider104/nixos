{ config, pkgs, lib, ... }:

let
  myModuleName = "ly-niri";
  myModulePackages = with pkgs; [
    cmatrix
  ];
in
{
  options.${myModuleName} = {
    enable = lib.mkEnableOption "${myModuleName}";
    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };
  };

  config = lib.mkIf config.${myModuleName}.enable {
    ${myModuleName}.packages = myModulePackages;

    # services.gnome.gnome-keyring.enable = true;
    # security.pam.services.ly.enableGnomeKeyring = true;

    services.displayManager = {
      ly = {
        enable = true;
        settings = {
          animate = true;
          animation = "matrix";
          # Add your user here if not using autoLogin
          # user = "slider";
        };
      };

      autoLogin = {
        enable = true;
        user = "slider";
        # Optional: Set a specific shell (defaults to niri session)
        # defaultShell = pkgs.bashInteractive;
      };

      defaultSession = "niri";

      sessionPackages = [ pkgs.niri ];
    };

    # systemd.services.display-manager.after = [
    #   "sound.target"
    #   "sys-subsystem-pci-devices-0000:03:00.0.device"
    #   "sys-subsystem-pci-devices-0000:73:00.0.device"
    # ];

    # systemd.services.display-manager.wants = [
    #   "sound.target"
    # ];

    # systemd.user.services.polkit-gnome-authentication-agent-1 = {
    #   enable = true;
    # };
  };
}
