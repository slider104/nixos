{ lib, pkgs, ... }:
with lib;
{
  config = {
    environment.systemPackages = with pkgs; [
      bashInteractive
      bat
      nitch
    ];
    programs.bash = {
      enable = true;
      # Optional: Set bash as the default shell for new users if desired
      # shell = "${pkgs.bashInteractive}/bin/bash";
    };
    environment.etc = {
      "profile.d/01-system-aliases.sh".text = ''
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
      # Ensure the script has execute permissions
      "profile.d/01-system-aliases.sh".mode = "0755";
    };
  };
}
