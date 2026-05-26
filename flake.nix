{
  description = "Custom icons authored by me";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        let
          python = pkgs.python314.withPackages (ps: with ps; [
            fontforge
          ]);
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = [ python pkgs.ty pkgs.ruff ];
          };
        };
    };
}
