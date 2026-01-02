{ config, pkgs, ... }:
{
  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["nfs"];
  boot.kernelParams = [ "i915.enable_guc=3" ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # Required for modern Intel GPUs (Xe iGPU and ARC)
      intel-media-driver     # VA-API (iHD) userspace
      vpl-gpu-rt             # oneVPL (QSV) runtime
      intel-compute-runtime  # OpenCL (NEO) + Level Zero for Arc/Xe
    ];
  };
  # May help if FFmpeg/VAAPI/QSV init fails (esp. on Arc with i915):
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";     # Prefer the modern iHD backend
    # VDPAU_DRIVER = "va_gl";      # Only if using libvdpau-va-gl
  };

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "transcode"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.justin = {
    isNormalUser = true;
    description = "Justin Herndon";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Install firefox.
  #programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim
     git
     ffmpeg-full
     tailscale
     pciutils
     uv
  ];

  #programs.nix-ld.enable = true;

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  services.rpcbind.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];

  # Enable the KDE Plasma Desktop Environment and VNC server
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;
  #services.xrdp.enable = true;
  #services.xrdp.defaultWindowManager = "startplasma-x11";
  #services.xrdp.openFirewall = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  #services.pulseaudio.enable = false;
  #security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #};

  systemd.mounts = [{
      type = "nfs";
        mountConfig = {
          Options = "noatime";
      };
    what = "openmediavault.fossheadscale.com:/nas";
    where = "/mnt/nas";
  }];

  systemd.automounts = [{
    wantedBy = [ "multi-user.target" ];
    automountConfig = {
      TimeoutIdleSec = "0";
    };
    where = "/mnt/nas";
  }];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.11"; # Did you read the comment?
}
