{ config, pkgs, lib, ... }:
let
  username = "slider";
  userGroup = "users";
  configDir = ".config/zed";
  pkg = [
    pkgs.zed-editor
  ];
  configFiles = [
    { source = ../../dotfiles/zed/settings.json; target = "settings.json"; }
  ];
  imports = [
  ];
  userHome = config.users.users.${username}.home;
  userName = config.users.users.${username}.name;
  rules = map (file: [
    "d ${userHome}/${configDir} 0755 ${userName} ${userGroup} -"
    "L+ ${userHome}/${configDir}/${file.target} - - - - ${file.source}"
  ]) configFiles;
  flatRules = lib.flatten rules;
in
{
  environment.systemPackages = if pkg != [] then pkg else [];
  systemd.tmpfiles.rules = flatRules;
  imports = lib.flatten (if imports != [] then imports else []);
}
