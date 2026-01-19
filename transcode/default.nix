{ config, pkgs, ... }:
{
  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
      ./services.nix
    ];
  boot  = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["nfs"];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "America/Chicago";
  nixpkgs.config.allowUnfree = true;
  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
    };
    systemPackages = with pkgs; [
      vim
      git
      ffmpeg-full
      tailscale
      pciutils
      actual-server
      jellyfin
      jellyfin-web
      caddy
      #immich
      #uv
      #iperf
    ];
  };
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
  networking = {
    networkmanager.enable = true;
    hostName = "transcode"; # Define your hostname.
    firewall.enable = false;
  };
  users.users.justin = {
    isNormalUser = true;
    description = "Justin Herndon";
    extraGroups = [ "networkmanager" "wheel" ];
    #packages = with pkgs; [
    #  kdePackages.kate
    #];
  };
  system.stateVersion = "25.11"; # Did you read the comment?
}
