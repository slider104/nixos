{ config, pkgs, lib, ... }:
let
  myModuleName = "bash";
  myModulePackages = with pkgs; [
    nitch
  ];
  aliasScript = ''
    #! /usr/bin/env bash
    # Aliases
    alias ll='ls -la'
    alias nrs='sudo nixos-rebuild switch --flake ~/nixos#nixos'
    alias nrb='sudo nixos-rebuild boot --flake ~/nixos#nixos'
    alias nck='cd ~/nixos && nix flake check && cd -'
    alias ncg='cd ~/nixos && sudo nix-collect-garbage --delete-older-than 30d && cd -'
    alias nup='cd ~/nixos && nix flake update && sudo nixos-rebuild boot --flake ~/nixos#nixos 2>&1 | tee logs/update_$(date +%F-%T).log && cd -'

    # Custom prompt (applies to all users)
    export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \$ '

    # Nitch integration
    if command -v nitch &> /dev/null; then
      nitch
    fi
  '';
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

    programs.bash = {
      enable = true;
      interactiveShellInit = aliasScript;
    };
    environment.etc."profile.d/01-system-aliases.sh" = {
      text = aliasScript;
      mode = "0755";
      user = "slider";
      group = "users";
    };
  };
}
