{
  description = "nix-config";

  inputs = {
    # Use `github:NixOS/nixpkgs/nixpkgs-26.05-darwin` to use Nixpkgs 26.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    # Use `github:nix-darwin/nix-darwin/nix-darwin-26.05` to use Nixpkgs 26.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs }:
    let
      # Machine builder: base config + any extra modules per machine.
      # Also exported as `lib.mkMac` so other flakes (e.g. a work overlay
      # repo) can compose their own machines on top of this base.
      mkMac = { user, darwinModules ? [ ], homeModules ? [ ] }:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit user; };
          modules = [
            ./configuration.nix
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit user; };
              home-manager.users.${user}.imports = [ ./home.nix ] ++ homeModules;
            }
          ] ++ darwinModules;
        };
    in
    {
      lib = { inherit mkMac; };

      darwinConfigurations."personal" = mkMac { user = "gingerninja"; };
    };
}
