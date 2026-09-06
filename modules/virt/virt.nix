{ config, pkgs, lib, ... }:

let
  myModuleName = "virt";
  myModulePackages = with pkgs; [
    qemu
    virt-manager
    virt-viewer
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

    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ ];
    };

    systemd.services.libvirtd.serviceConfig.ExecStart = lib.mkForce "${pkgs.libvirt}/bin/libvirtd --config /etc/libvirt/libvirtd.conf";

      environment.etc."libvirt/libvirtd.conf".text = ''
        unix_sock_ro_perms = "0777"
        unix_sock_rw_perms = "0770"
        auth_unix_ro = "none"
        auth_unix_rw = "none"
        auth_polkit = 0
      '';

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.libvirt.unix.manage" &&
            subject.isInGroup("libvirt")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
