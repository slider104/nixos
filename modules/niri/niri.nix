{ config, pkgs, lib, ... }:
let
  username = "slider";
  userGroup = "users";
  configDir = ".config/niri";
  pkg = [
    pkgs.alacritty
    pkgs.brave
    pkgs.capitaine-cursors
    pkgs.nemo
    pkgs.nemo-fileroller
    pkgs.niri
    pkgs.superfile
    pkgs.swaybg
    pkgs.xwayland-satellite
  ];
  configFiles = [
    { source = ../../dotfiles/niri/config.kdl; target = "config.kdl"; }
  ];
  imports = [
    ../waybar/waybar.nix
    ../fuzzel/fuzzel.nix
    ../wofi/wofi.nix
    ../zed/zed.nix
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
  systemd.services.niri = {
    Type = "simple";
    User = "${username}";
    ExecStart = "${pkgs.niri}/bin/niri";
    # ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
    Restart = "on-failure";
    RestartSec = "5s";
    After = [ "display-manager.service" "systemd-user-session.service" ];
    Wants = [ "display-manager.service" ];
    # Environment = "XDG_RUNTIME_DIR=/run/user/%U";
  };
  wantedBy = [ "default.target" ];
}
