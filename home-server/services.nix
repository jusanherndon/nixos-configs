{
  services.openssh.enable = true;
  services.actual.enable = true;

  services.deluge = {
    enable = true;
    group = "deluge";
    web = { 
      enable = true;
      openFirewall = true;
    };
    config = {
      share_ratio_limit = "1.0";
    };
    dataDir = "/media/deluge";
    openFirewall = true;
  };

  services.jellyfin = {
    enable = true;
    user="jellyfin";
    openFirewall = true;
    configDir = "/mnt/nas/jellyfin";
  };
  
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  systemd.mounts = [{
      type = "nfs";
        mountConfig = {
          Options = "noatime";
      };
    what = "openmediavault.lan:/nas";
    where = "/mnt/nas";
  }];

  systemd.automounts = [{
    wantedBy = [ "multi-user.target" ];
    automountConfig = {
      TimeoutIdleSec = "0";
    };
    where = "/mnt/nas";
  }];
  
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };


}
