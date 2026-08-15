{
  description = "Development environment for vsWaybar Studio";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # Switched to python312 to resolve Sphinx compatibility issues
        pythonEnv = pkgs.python312.withPackages (ps: with ps; [
          pygobject3
          cairocffi
          json5
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv
            pkgs.gtk3
            pkgs.webkitgtk_4_1
            pkgs.gobject-introspection
            pkgs.git
          ];

          shellHook = ''
            export GI_TYPELIB_PATH=${pkgs.gtk3}/lib/girepository-1.0:${pkgs.webkitgtk_4_1}/lib/girepository-1.0:$GI_TYPELIB_PATH
            echo "vsWaybar Studio environment ready."
            echo ""
            echo "To launch the GUI, run:"
            echo "  ./vswaybar-studio"
            echo ""
            if [ ! -d "vsWaybar-Studio" ]; then
              git clone https://github.com/victorsosaMx/vsWaybar-Studio.git
            fi
            cd vsWaybar-Studio
          '';
        };
      }
    );
}
