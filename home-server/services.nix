{
  services.openssh.enable = true;

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
    dataDir = "/mnt/nas/media";
    configDir = "/mnt/nas/jellyfin";
  };


  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

}
