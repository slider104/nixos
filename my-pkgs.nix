{ config, pkgs, lib, ... }:

let
  myModuleName = "my-pkgs";
  myModulePackages = [
    pkgs.bat
    pkgs.bottom
    pkgs.fresh-editor
    pkgs.libreoffice
    pkgs.lufus
    pkgs.mediawriter
    pkgs.nil
    pkgs.rnote
    pkgs.seahorse
    pkgs.shortwave
    pkgs.superfile
    pkgs.vulkan-tools
    pkgs.wget
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
  };
}
