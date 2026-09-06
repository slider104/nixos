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
        "kvm"
        "libvirt"
        "networkmanager"
        "render"
        "video"
        "wheel"
      ];
    };
  };
}
