{ config, pkgs, lib, ... }:
let
  username = "slider";
  configDir = ".config/fuzzel";
  pkg = [
    pkgs.fuzzel
  ];
  configFiles = [
    { source = ../../dotfiles/fuzzel/fuzzel.ini; target = "fuzzel.ini"; }
  ];
  imports = [
  ];
  userHome = config.users.users.${username}.home;
  userName = config.users.users.${username}.name;
  rules = map (file: [
    "d ${userHome}/${configDir} 0755 ${userName} ${userName} -"
    "L+ ${userHome}/${configDir}/${file.target} - - - - ${file.source}"
  ]) configFiles;
  flatRules = lib.flatten rules;
in
{
  environment.systemPackages = if pkg != [] then pkg else [];
  systemd.tmpfiles.rules = flatRules;
  imports = lib.flatten (if imports != [] then imports else []);
}
