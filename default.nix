let

  nixpkgsRev = "32b46dd";
  compilerVersion = "ghc865";
  compilerSet = pkgs.haskell.packages."${compilerVersion}";

  githubTarball = owner: repo: rev:
    builtins.fetchTarball { url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz"; };

  pkgs = import (githubTarball "NixOS" "nixpkgs" nixpkgsRev) { inherit config; };
  gitIgnore = pkgs.nix-gitignore.gitignoreSourcePure;

  config = {
    packageOverrides = super: let self = super.pkgs; in rec {
      haskell = super.haskell // {
        packageOverrides = self: super: {
          haskell-nix = super.callCabal2nix "haskell-nix" (gitIgnore [./.gitignore] ./.) {};
        };
      };
    };
  };

  ghcide = (import (githubTarball "cachix" "ghcide-nix" "master") {})."ghcide-${compilerVersion}";

in {
  inherit pkgs;
  shell = compilerSet.shellFor {
    packages = p: [p.haskell-nix];
    buildInputs = with pkgs; [
      compilerSet.cabal-install
      ghcide
      ghcid
      hlint
      haskellPackages.brittany
      haskellPackages.implicit-hie
    ];
  };
}
