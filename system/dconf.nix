{
  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    }
  ];
}
