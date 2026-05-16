{
  description = "diralias - manage directory aliases as filesystem symlinks";

  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = (
    { self, nixpkgs, systems }:
    let
      forAllSystems = nixpkgs.lib.genAttrs (import systems);
    in {
      packages = forAllSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.callPackage ./package.nix { };
      });

      devShells = forAllSystems (system: {
        default = let
          pkgs = nixpkgs.legacyPackages.${system};
        in pkgs.mkShell {
          packages = [ pkgs.bats ];
        };
      });
    }
  );
}
