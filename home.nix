{ config, lib, pkgs, ... }:

let
  cfg = config.programs.doomEmacs;

  emacsWithPatches = pkgs.emacs.override { withNativeCompilation = true; };

  emacsPkg = (pkgs.emacsPackagesFor emacsWithPatches).emacsWithPackages (epkgs: [ epkgs.vterm ]);

  swedishDict = pkgs.writeTextFile {
    name = "swedish-dict";
    text = builtins.readFile (pkgs.fetchFromGitHub {
      owner = "martinlindhe";
      repo = "wordlist_swedish";
      rev = "master";
      sha256 = "sha256-kBmexyxcSGV94h7FJ6g4TJobaarzFFiJ2uzIU0kVPp8=";
    } + "/swe_wordlist");
  };

  englishDict = pkgs.writeTextFile {
    name = "english-dict";
    text = builtins.readFile (pkgs.fetchFromGitHub {
      owner = "dwyl";
      repo = "english-words";
      rev = "master";
      sha256 = "sha256-PfBQ9iavOLx7M8+j0TXASUxVamPiQn2YXsiuUmz4XCg=";
    } + "/words.txt");
  };

  treesitterGrammars = pkgs.stdenv.mkDerivation rec {
    pname = "treesitter-grammars";
    version = "0.13.26";

    src = if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.fetchzip {
        url = "https://github.com/emacs-tree-sitter/tree-sitter-langs/releases/download/${version}/tree-sitter-grammars.aarch64-apple-darwin.v${version}.tar.gz";
        sha256 = "sha256-GgVRt2fn3tMvIRYhyDysUMQDHNB9JM6jA8+gPNgv04A=";
        stripRoot = false;
      }
    else
      pkgs.fetchzip {
        url = "https://github.com/emacs-tree-sitter/tree-sitter-langs/releases/download/${version}/tree-sitter-grammars-linux-${version}.tar.gz";
        sha256 = "sha256-VzB1VMOM59JtPQSbzbzbK2z5I5i7Tl0s6QAZ875A4t0=";
        stripRoot = false;
      };

    buildPhase = "";

    installPhase = ''
      mkdir -p $out
      mv * $out

      cd $out

      shopt -s nullglob
      for f in *.dylib *.so; do
        ln -s "$f" "libtree-sitter-$f"
      done
    '';
  };

  hunspellDictionary = pkgs.stdenv.mkDerivation {
    name = "hunspell-dicts";

    src = pkgs.fetchFromGitHub {
      owner = "wooorm";
      repo = "dictionaries";
      rev = "master";
      sha256 = "sha256-trItzxKmZcTSplDd27PhJRbd4rvefghxiY4d67QnsEE=";
    };

    buildPhase = "";

    installPhase = ''
      mkdir -p $out
      mv dictionaries/en/index.aff $out/en_US.aff
      mv dictionaries/en/index.dic $out/en_US.dic
      mv dictionaries/sv/index.aff $out/sv_SE.aff
      mv dictionaries/sv/index.dic $out/sv_SE.dic
    '';
  };

  doomEmacsSrc = builtins.fetchGit {
    url = "https://github.com/doomemacs/doomemacs.git";
    rev = "01d68aaf6bd7db073365385cd82e1ad7e815295c";
  };

  tex = pkgs.texliveSmall.withPackages (
    ps: with ps; [
      scheme-medium
      dvisvgm
      dvipng
      wrapfig
      amsmath
      ulem
      hyperref
      capt-of
    ]
  );
in
{
  options.programs.doomEmacs = {
    enable = lib.mkEnableOption "Doom Emacs, managed via this flake";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      EMACSDIR = "${config.xdg.configHome}/emacs";
      DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
      DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
      TREESITTER_GRAMMARS = "${treesitterGrammars}";
      DICPATH = "${hunspellDictionary}";
    };

    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    programs.emacs = {
      enable = true;
      package = emacsPkg;
    };

    xdg.configFile."doom".source = pkgs.runCommand "doom-config" { } ''
      mkdir -p $out
      cp ${./init.el} $out/init.el
      cp ${./config.org} $out/config.org
      cp ${./packages.el} $out/packages.el
    '';

    xdg.configFile."emacs".source = doomEmacsSrc;

    home.packages = with pkgs; [
      hunspell
      ripgrep
      fd
      nerd-fonts.symbols-only
      noto-fonts-monochrome-emoji
      tree
      pandoc
      postgresql
      tex
      mermaid-cli
      copilot-language-server
      netcoredbg
      bash-language-server
      dockerfile-language-server
      yaml-language-server
      vscode-json-languageserver
      sqlite
      wordnet
      prettier
    ];
  };
}
