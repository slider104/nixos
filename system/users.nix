{
  users = {
    users."slider" = {
      isNormalUser = true;
      description = "slider";
      extraGroups = [
        "audio"
        "git"
        "input"
        "networkmanager"
        "render"
        "video"
        "wheel"
      ];
    };
  };
}
