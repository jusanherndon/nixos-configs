{
  description = "This is my home-server config"
  # Rebuild using nixos-rebuild switch --flake '/path/to/flake/directory#hostname`
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };
  outputs = { nixpkgs, ... }: {
    nixosConfigurations.home-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./home-server.nix ];
    };
  };
}
