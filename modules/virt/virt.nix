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

    programs.virt-manager.enable = true;
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    services.spice-vdagentd.enable = true;
    services.qemuGuest.enable = true;
  };
}
