{ config, pkgs, lib, ... }:
let
  myModuleName = "bash";
  myModulePackages = with pkgs; [
    nitch
  ];
  aliasScript = ''
    #!/usr/bin/env bash
    # Aliases
    alias cat='bat'
    alias ll='ls -la'
    alias nrs='sudo nixos-rebuild switch --flake ~/nixos#nixos'
    alias nck='cd ~/nixos && nix flake check && cd -'
    alias ncg='cd ~/nixos && sudo nix-collect-garbage --delete-older-than +5 && cd -'

    # Custom prompt (applies to all users)
    export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \$ '

    # Nitch integration (only runs if nitch is installed)
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
    programs.bash.enable = true;
    environment.etc."profile.d/01-system-aliases.sh".text = aliasScript;
    environment.etc."profile.d/01-system-aliases.sh".mode = "0755 slider users";
  };
}
