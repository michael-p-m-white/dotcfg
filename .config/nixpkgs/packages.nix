with builtins;
let
  overrideOutputsToInstall = pkg: outputs: pkg // { meta = pkg.meta // {outputsToInstall = outputs;};};
in
  { pkgs ? 
      import <nixos> {}
  }:
  with pkgs;
  {
    inherit (pkgs)
      ansible
      bash-completion
      clojure
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
      gradle
      graphviz
      guile
      htop
      jq
      #kubernetes
      lilypond
      lfe
      maven
      ncdu
      nix-bash-completions
      nix-prefetch-git
      nix-serve
      nmap
      nodejs
      #packer
      rlwrap
      sbcl
      sshpass
      sqlite
      sqlitebrowser
      telnet
      #terraform
      #terragrunt
      tightvnc
      tree
      vim
      wget
      whois
      wireshark
      ;

    inherit (pkgs.gitAndTools)
      gitSVN
      tig
      ;

    inherit (lispPackages)
      quicklisp
      ;

    inherit (xorg)
      xev
      ;

    jdk = oraclejdk // {oraclejdk.meta.keep = true;};

    openssl = (overrideOutputsToInstall openssl_1_1_0 [ "bin" "dev" "out" "man" ]);
    tmux = (overrideOutputsToInstall tmux [ "out" "man" ]);
  }
