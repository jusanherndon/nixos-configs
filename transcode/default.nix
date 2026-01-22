{ config, pkgs, ... }:
{
  imports =
    [ 
      ./../configuration.nix
      ./hardware-configuration.nix
      ./services.nix
    ];
  boot  = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
    };
    systemPackages = with pkgs; [
      ffmpeg-full
      pciutils
      actual-server
      jellyfin
      jellyfin-web
      #immich
      #uv
      #iperf
    ];
  };
  networking = {
    networkmanager.enable = true;
    hostName = "transcode"; # Define your hostname.
    firewall.enable = false;
  };
  system.stateVersion = "25.11"; # Did you read the comment?
}
