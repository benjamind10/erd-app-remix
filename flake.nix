
{
  description = "Frontend development environment with React, TypeScript, ESLint, Yarn, and Heroku CLI";

  inputs = {
    # Use the latest Nix Packages
    nixpkgs.url = "github:NixOS/nixpkgs";

    # flake-utils for handling multiple systems and more organized outputs
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            # Frontend Development Tools
            pkgs.nodejs               # Node.js runtime for React
            pkgs.yarn                 # Yarn package manager
            pkgs.typescript           # TypeScript language support

            # LSP Servers and Linters
            pkgs.nodePackages.typescript-language-server  # LSP server for TypeScript
            pkgs.nodePackages.eslint                     # Linting tool for JavaScript/TypeScript
            pkgs.nodePackages.prettier                   # Code formatter
          ];

          # Optional: Additional Environment Setup
          shellHook = ''
            # Initialize Node.js environment, Yarn version, etc.
            export PATH="$HOME/.yarn/bin:$HOME/.npm-global/bin:$PATH"
            
            # Set up a trap to kill all node processes on shell exit
            trap 'pkill -P $$' EXIT
          '';
        };
      }
    );
}
