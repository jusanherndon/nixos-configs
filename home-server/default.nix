{ config, pkgs, ... }:

{
  imports =
    [ 
      /etc/nixos/hardware-configuration.nix 
      ./services.nix
      ./users.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
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

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim 
    git
    deluged
    jellyfin
    jellyfin-web
  ];


 fileSystems."/mnt/nas" = {
    device = "192.168.1.97:/nas";
    fsType = "nfs";
    options = [
        "x-systemd.automount"
        "x-systemd.idle-timeout=300"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 8000 ];
  networking.firewall.allowedUDPPorts = [ 8000 ];
  system.stateVersion = "24.11"; 
}
