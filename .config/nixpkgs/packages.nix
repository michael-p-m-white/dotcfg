with builtins;
let
  flakeRef = github:NixOS/nixpkgs/2039c98a8afec8ff3273a3ac34b9e3864174ed94;
  flake = builtins.getFlake flakeRef;
  defaultPackages = flake.legacyPackages."${builtins.currentSystem}";
in
  { pkgs ?
    defaultPackages
  }:
  let
    overrideOutputsToInstall = pkg: outputs: pkgs.lib.addMetaAttrs {outputsToInstall = outputs;} pkg;
  in
  rec {
    inherit (pkgs)
      alacritty
      ammonite
      asunder
      audacity
      bash-completion
      broot
      cabal-install
      chromium
      coq
      delta
      dmenu
      dhall
      dhall-json
      dhall-nix
      dos2unix
      eaglemode
      ffmpeg
      file
      filezilla
      firefox
      fzf
      ghc
      gnuplot
      graphviz
      guile
      hanazono
      htop
      jq
      keepass
      lfe
      libreoffice
      lilypond
      ncdu
      nix-bash-completions
      nix-prefetch-git
      nmap
      nodejs
      p7zip
      rlwrap
      sbcl
      scala
      slack
      sshpass
      sqlitebrowser
      swiProlog
      telnet
      tetex
      tree
      vim
      vlc
      wget
    ;

  jdk = pkgs.openjdk11;
  sbt = pkgs.sbt.override { jre = jdk.jre or jdk; };

  inherit (pkgs.elmPackages)
    elm
    elm-analyse
    elm-format
    elm-live
    ;
  
    discord =
      let
        inherit (pkgs) fetchurl;
        version = "0.0.17";
      in
        pkgs.discord.override {
          inherit version;
          src = fetchurl {
            url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
            sha256 = "058k0cmbm4y572jqw83bayb2zzl2fw2aaz0zj1gvg6sxblp76qil";
          };
        };
  
    emacs = pkgs.emacsWithPackages
      (epkgs: with epkgs;
        [
          ace-jump-mode
          aggressive-indent
          company-coq
          dhall-mode
          elm-mode
          haskell-mode
          lfe-mode
          lsp-haskell
          lsp-metals
          lsp-mode
          lsp-ui
          magit
          magit-delta
          multiple-cursors
          nix-mode
          paredit
          prolog-mode
          proof-general
          rust-mode
          scala-mode
          shm
          slime
          structured-haskell-mode
          yaml-mode
        ]
      )
    ;

    inherit (pkgs.jetbrains)
      idea-community
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
    sqlite = overrideOutputsToInstall (pkgs.sqlite) [ "bin" "out" ];
    tmux = (overrideOutputsToInstall pkgs.tmux [ "out" "man" ]);
  }
