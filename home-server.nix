{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix 
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
  users.users.justin = {
    isNormalUser = true;
    description = "Justin";
    extraGroups = [ "networkmanager" "wheel" "deluge" "jellyfin" ];
    packages = with pkgs; [];
  };

  users.users.deluge = {
    extraGroups = [ "deluge" ];
  };

  users.users.jellyfin = {
    extraGroups = [ "jellyfin" ];
  };

  fileSystems."/mnt/nas" = {
    device = "192.168.1.97:/nas";
    fsType = "nfs";
  };


  home-manager.users.justin = {
  
  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    userName = "Justin Herndon";
    userEmail = "jherndon111@gmail.com";
  };
  
  home.stateVersion = "24.05";
};

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim 
    git
    deluged
    jellyfin
    jellyfin-web
  ];


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.deluge = {
    enable = true;
    group = "deluge";
    web = { 
      enable = true;
      openFirewall = true;
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
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  system.stateVersion = "24.05"; # Did you read the comment?
}
