{
  users.users = {
      justin = {
        isNormalUser = true;
        description = "Justin";
        extraGroups = [ "networkmanager" "wheel" "deluge" "jellyfin" ];
        packages = with pkgs; [];
      };

      deluge = {
        extraGroups = [ "deluge" ];
      };

      jellyfin = {
        extraGroups = [ "jellyfin" ];
      };
  };
  home-manager.users.justin = {
  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    userName = "Justin Herndon";
    userEmail = "jherndon111@gmail.com";
  };
  
  home.stateVersion = "25.05";
};
}
