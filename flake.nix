{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        defaultPackage = packages.agda-template;
        packages = {
          agda-template = pkgs.runCommand "agda-template"
            {
              buildInputs = [
                pkgs.gnumake
                pkgs.pandoc
                (pkgs.agda.withPackages (p: [ p.standard-library ]))
              ];
            }
            ''
              ln -s ${./fonts} fonts
              ln -s ${./styles} styles
              ln -s ${./index.md} index.md
              ln -s ${./header.html} header.html
              ln -s ${./Makefile} Makefile
              ln -s ${./agda-template.agda-lib} agda-template.agda-lib
              mkdir src && ln -s ${./src}/*.lagda.md src
              ${pkgs.gnumake}/bin/make OUT_DIR=$out
            '';
        };
        checks = {
          build = self.defaultPackage."${system}";
        };
      }
    );
}
