{ config, pkgs, ... }: {

  imports = [
    # ./modules/#.nix
  ];

  home.username = "slider";
  home.homeDirectory = "/home/slider";
  home.stateVersion = "26.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      cat = "bat";
      ll = "ls -la";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
      nck = "cd ~/nixos && nix flake check && cd -";
      ncg = "cd ~/nixos && sudo nix-collect-garbage --delete-older-than +5 && cd -";
    };
    # profileExtra = ''
    #   # Only start if:
    #   # 1. No Wayland session is active yet
    #   # 2. We are on TTY1 (matches the getty autologin)
    #   if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    #       exec uwsm start -S niri-uwsm.desktop
    #   fi
    # '';
    initExtra = ''
      export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
      if command -v nitch &> /dev/null; then nitch; fi
    '';
  };
  home.packages = with pkgs; [
    nitch
  ];
}
