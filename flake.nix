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
          python = pkgs.python314.withPackages (
            ps: with ps; [
              fontforge
            ]
          );

          fonts = pkgs.stdenv.mkDerivation {
            name = "sheb-icons";
            version = "1.0.0";
            src = ./.;
            buildInputs = [ python ];

            buildPhase = ''
              python main.py generate
            '';

            installPhase = ''
              mkdir -p $out/share/fonts/truetype
              cp icons.ttf $out/share/fonts/truetype/
            '';
          };
        in
        {
          packages.default = fonts;
          devShells.default = pkgs.mkShell {
            buildInputs = [
              python
              pkgs.ty
              pkgs.ruff
            ];
          };
        };
    };
}
