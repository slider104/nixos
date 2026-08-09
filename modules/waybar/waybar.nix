{ config, pkgs, lib, ... }:
let
  username = "slider";
  configDir = ".config/waybar";
  pkg = [
    pkgs.brightnessctl
    pkgs.fuzzel
    pkgs.pavucontrol
    pkgs.lm_sensors
    pkgs.waybar
  ];
  configFiles = [
    { source = ../../dotfiles/waybar/config; target = "config"; }
    { source = ../../dotfiles/waybar/style.css; target = "style.css"; }
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
