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
        # vsWaybar Studio requires Python with PyGObject (GTK3) and Cairo
        pythonEnv = pkgs.python311.withPackages (ps: with ps; [
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
            pkgs.webkit2gtk_4_1  # Critical for the live bar preview
            pkgs.gobject-introspection
            pkgs.git
          ];

          shellHook = ''
            # Ensure Python can find the GTK3 and WebKit type libraries
            export GI_TYPELIB_PATH=${pkgs.gtk3}/lib/girepository-1.0:${pkgs.webkit2gtk_4_1}/lib/girepository-1.0:$GI_TYPELIB_PATH

            echo "vsWaybar Studio environment ready."
            echo "Run the following to clone and start:"
            echo "git clone https://github.com/victorsosaMx/vsWaybar-Studio.git"
            echo "cd vsWaybar-Studio"
            echo "python3 vsbar.py  # Or ./vswaybar-studio depending on entry point"
          '';
        };
      }
    );
}
