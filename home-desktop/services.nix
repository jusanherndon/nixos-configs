{
  services = {
    openssh.enable = true;
    rpcbind.enable = true; # needed for NFS
    #printing.enable = true;
    pulseaudio.enable = false;
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    rtkit.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
  };

  systemd = {
    mounts = [{
      type = "nfs";
        mountConfig = {
          Options = "noatime";
      };
    what = "openmediavault.lan:/nas";
    where = "/mnt/nas";
    }];
    automounts = [{
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "0";
      };
      where = "/mnt/nas";
    }];
  };
}
