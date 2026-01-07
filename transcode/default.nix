{ config, pkgs, ... }:
{
  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
      ./services.nix
    ];

  # Bootloader.
  boot  = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["nfs"];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # May help if FFmpeg/VAAPI/QSV init fails (esp. on Arc with i915):
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";     # Prefer the modern iHD backend
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "transcode"; # Define your hostname.
    firewall.enable = false;
  };

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
     iperf
     pciutils
     uv
     actual-server
     jellyfin
     jellyfin-web
     caddy
  ];

  #programs.nix-ld.enable = true;
  system.stateVersion = "25.11"; # Did you read the comment?
}
