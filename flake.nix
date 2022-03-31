{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" "i686-linux" "aarch64-linux" ] (
      system: let
        pkgs = nixpkgs.legacyPackages."${system}";
      in
        rec {
          # `nix build`
          packages = rec {
            jenkinsfile-runner = pkgs.callPackage ./pkgs/jenkinsfile-runner.nix { };
            plugin-installation-manager = pkgs.callPackage ./pkgs/plugin-installation-manager.nix { };
          };
          defaultPackage = packages.jenkinsfile-runner;

          # `nix run`
          apps = {
            jenkinsfile-runner = flake-utils.lib.mkApp {
              drv = packages.jenkinsfile-runner;
            };
            plugin-installation-manager = flake-utils.lib.mkApp {
              drv = packages.plugin-installation-manager;
            };
          };
          defaultApp = apps.jenkinsfile-runner;

          # `nix develop`
          devShell = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [ ];
          };
        }
    );
}
