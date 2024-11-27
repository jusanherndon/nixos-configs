{
  description = "This is my home-server config";
  # Rebuild using nixos-rebuild switch --flake --impure '/path/to/flake/directory#hostname`
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, ... }: {
    nixosConfigurations.home-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./home-server.nix ];
    };
  };
}

