with builtins;
let
  overrideOutputsToInstall = pkg: outputs: pkg // { meta = pkg.meta // {outputsToInstall = outputs;};};
in
  { pkgs ?
      import <nixos> {}
  }:
  {
    inherit (pkgs)
      bash-completion
      cabal-install
      dmenu
      dhall
      dhall-json
      dhall-nix
      dos2unix
      emacs
      file
      filezilla
      firefox
      ghc
      gnuplot
      graphviz
      guile
      htop
      jdk
      jq
      keepass
      lilypond
      lfe
      ncdu
      nix-bash-completions
      nix-prefetch-git
      nmap
      nodejs
      rlwrap
      sbcl
      sshpass
      sqlite
      sqlitebrowser
      telnet
      tetex
      tree
      unzip
      vim
      wget
      ;

    inherit (pkgs.emacsPackages)
      aggressive-indent
      lsp-haskell
      lsp-mode
      lsp-ui
      nix-mode
      shm
      slime
      ;

    inherit (pkgs.haskellPackages)
      haskell-language-server
      ;

    plover = pkgs.plover.dev;

    inherit (pkgs.gitAndTools)
      gitSVN
      tig
      ;

    inherit (pkgs.lispPackages)
      quicklisp
      ;

    inherit (pkgs.xorg)
      xev
      ;

    openssl = (overrideOutputsToInstall (pkgs.openssl) [ "bin" "dev" "out" "man" ]);
    tmux = (overrideOutputsToInstall pkgs.tmux [ "out" "man" ]);
  }
