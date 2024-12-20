with builtins;
let
  flakeRef = "nixpkgs"; # Pinned by system configuration
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
      alacritty-theme
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
      evtest
      fasm
      ffmpeg
      file
      filezilla
      firefox
      fzf
      gforth
      ghc
      gimp
      gnumake
      gnuplot
      graphviz
      guile
      hanazono
      htop
      inetutils
      jujutsu
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
      qgis
      ripgrep
      rlwrap
      sbcl
      scala
      slack
      sshpass
      sqlitebrowser
      # Prolog is failing to evaluate for nixos-23.05 as it depends on openssl-1.1.1u, which is marked as insecure.
      # Commenting out so I can update without dealing with it late at night.
      # swiProlog
      tree
      vim
      vlc
      wezterm
      wget
    ;

    texlive = let texlive = pkgs.texlive;
              in
                texlive.combine {
                  inherit (texlive)
                    changepage
                    scheme-basic
                    metafont
                    sectsty
                  ;
                };

    # Games. Keeping separate, just because.
    inherit (pkgs)
      mindustry
    ;

  jdk = pkgs.openjdk11;
  sbt = pkgs.sbt.override { jre = jdk.jre or jdk; };

  inherit (pkgs.elmPackages)
    elm
    elm-analyse
    elm-format
    elm-language-server
    elm-live
    elm-test
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
  
    emacs =
      let
        emacs29Packages = pkgs.emacsPackagesFor (pkgs.emacs29);
        emacsWithPackages = emacs29Packages.withPackages;
      in
        emacsWithPackages
          (epkgs: with epkgs;
            [
              aggressive-indent
              ascii-art-to-unicode
              avy
              company-coq
              dhall-mode
              elm-mode
              geiser
              geiser-guile
              haskell-mode
              lfe-mode
              lsp-haskell
              lsp-metals
              lsp-mode
              lsp-ui
              lua-mode
              magit
              magit-delta
              multiple-cursors
              nix-mode
              org-roam
              paredit
              prolog-mode
              proof-general
              rust-mode
              scala-mode
              slime
              #structured-haskell-mode
              vterm
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
