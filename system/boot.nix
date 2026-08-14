{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.timeout = 1;
  # boot.loader.grub = {
  #   enable = true;
  #   device = "/dev/vda";
  #   useOSProber = false;
  # };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    # "vt.global_cursor_default=0"  # Hide TTY cursor
    # "plymouth.enable=0"           # Disable Plymouth splash (often causes double cursor in VMs)
    # "loglevel=3"                  # Reduce boot noise
    # "amd_pstate=active"
    # "fs.inotify.max_user_watches=524288"
    # "snd_hda_intel.dmic_detect=0"
    # "amdgpu.gpu_recovery=1"
    "usbcore.autosuspend=-1"
  ];
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
