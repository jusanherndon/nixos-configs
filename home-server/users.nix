{
  users.users = {
      justin = {
        isNormalUser = true;
        description = "Justin";
        extraGroups = [ "networkmanager" "wheel" "deluge" ];
      };
      deluge = {
        extraGroups = [ "deluge" ];
      };
  };
}
