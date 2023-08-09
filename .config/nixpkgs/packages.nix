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
      agda
      alacritty
      alloy6
      ammonite
      asunder
      audacity
      bash-completion
      blender
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
      erlang
      fasm
      ffmpeg
      file
      filezilla
      firefox
      fzf
      gforth
      ghc
      gimp
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
      mpv
      ncdu
      nix-bash-completions
      nix-prefetch-git
      nmap
      nodejs
      ntfs3g
      obs-studio
      p7zip
      pass
      psensor
      ripgrep
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
        version = "0.0.22";
      in
        pkgs.discord.override {
          inherit version;
          src = fetchurl {
            url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
            sha256 = "sha256-F1xzdx4Em6Ref7HTe9EH7whx49iFc0DFpaQKdFquq6c=";
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
