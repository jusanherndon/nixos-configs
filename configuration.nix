{pkgs, specialArgs, ...}:
{
  boot.supportedFilesystems = ["nfs"];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "America/Chicago";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  users.users.justin = {
    isNormalUser = true;
    description = "Justin Herndon";
    extraGroups = [ "networkmanager" "wheel" "deluge" ];
    #packages = with pkgs; [
    #  kdePackages.kate
    #];
  };
  environment.systemPackages = with pkgs; [
    vim
    git
    caddy
    tailscale
  ];
  services = {
    openssh.enable = true;
    rpcbind.enable = true; 
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
      what = "openmediavault.fossheadscale.com:/nas";
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
