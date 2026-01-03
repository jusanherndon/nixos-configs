{ config, pkgs, ... }:
{
  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
      ./services.nix
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
    #packages = with pkgs; [
    #  kdePackages.kate
    #];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     vim
     git
     ffmpeg-full
     tailscale
     pciutils
     uv
     actual-server
     jellyfin
     jellyfin-web
     caddy
  ];

  #programs.nix-ld.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "25.11"; # Did you read the comment?
}
