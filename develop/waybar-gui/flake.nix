{
  description = "Development environment for Waybar Configurator GUI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = pkgs.python311.withPackages (ps: with ps; [
          pygobject3
          json5
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv
            pkgs.gtk4
            pkgs.libadwaita
            pkgs.gobject-introspection
            pkgs.git
          ];

          shellHook = ''
            export GI_TYPELIB_PATH=${pkgs.gtk4}/lib/girepository-1.0:${pkgs.libadwaita}/lib/girepository-1.0:$GI_TYPELIB_PATH
            echo "Waybar Configurator environment ready."
            echo "Run: git clone https://github.com/veitorman/Waybar-Configurator-GUI.git && cd Waybar-Configurator-GUI && python3 waybar_configurator.py"
          '';
        };
      }
    );
}
