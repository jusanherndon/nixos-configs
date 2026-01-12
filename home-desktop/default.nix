{ inputs, config, pkgs, specialArgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./services.nix
    ];

  boot = {
    loader = { 
      grub = { 
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
      };
    };
    supportedFilesystems = [ "nfs" ];
  };
  networking = {
    networkmanager.enable = true;
    hostName = "nixos-laptop";
  };
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
    jujutsu
    inputs.mdhtml.defaultPackage.${system}
    mosh
    fzf
    mtr
    tailscale
  ];

  users.users.justin = {
    isNormalUser= true;
    extraGroups = [ "networkManager" "wheel" "deluge" "jellyfish" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  system.stateVersion = "24.11";
}
