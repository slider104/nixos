{ config, pkgs, lib, ... }:

let
  myModuleName = "alacritty";
  myModulePackages = [
    pkgs.alacritty
  ];

  dotfilesDir = "/home/slider/nixos/dotfiles";
  configDir = ".config/alacritty";

  dotfiles = [
    {
      source = "${dotfilesDir}/alacritty/alacritty.toml";
      target = "alacritty.toml";
      mode = "0755";
    }
  ];

  username = "slider";
  userGroup = "users";
  userHome = "/home/${username}";

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

    system.activationScripts."${myModuleName}-dotfiles" = ''
      mkdir -p ${userHome}/${configDir}
      ${lib.concatMapStrings (file: ''
        cp ${file.source} ${userHome}/${configDir}/${file.target}
        chmod ${file.mode} ${userHome}/${configDir}/${file.target}
        chown ${username}:${userGroup} ${userHome}/${configDir}/${file.target}
      '') dotfiles}
    '';
  };
}
