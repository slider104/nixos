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

    virtualisation.libvirtd.enable = true;

    environment.etc."polkit-1/rules.d/50-libvirt.rules".text = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.libvirt.unix.manage" &&
            subject.isInGroup("libvirt")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
