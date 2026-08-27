{
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/0574158e-46bd-43a8-bd49-8e75304ce6f3";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.device-timeout=0"
      "x-systemd.automount"
    ];
  };
  # hardware.enableRedistributableFirmware = true;
  # hardware.cpu.amd.updateMicrocode = true;
}
