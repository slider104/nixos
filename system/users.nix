{
  users = {
    users."slider" = {
      isNormalUser = true;
      description = "slider";
      extraGroups = [
        "audio"
        "git"
        "i2c"
        "input"
        "networkmanager"
        "render"
        "video"
        "wheel"
      ];
    };
  };
}
