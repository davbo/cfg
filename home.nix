{ config, pkgs, ... }:

let
  starship = pkgs.callPackage ./starship.nix {
    inherit (pkgs.darwin.apple_sdk.frameworks) Security;
  };
  profile = "${config.home.profileDirectory}";
in {
  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # utils
    gcc
    coreutils-prefixed
    fd
    ripgrep
    shellcheck
    nixfmt
    plantuml
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science fi ]))
    exa
    # cloud stuff
    google-cloud-sdk
    awscli2
    terraform
    xz
    # languages
    rustup
    python3
    ruby
    jdk11
    maven
    nodejs
    # apps
    emacs
    # Fonts
    fira-code
    fira-code-symbols
    source-code-pro
    alegreya
    etBook
  ];

  home.sessionVariables = {
    PAGER = "less";
    EDITOR = "vim";
    PATH = "/nix/var/nix/profiles/default/bin:/usr/local/go/bin:$HOME/.nix-profile/bin:$HOME/go/bin:$PATH";
    GOPATH = "$HOME/go";
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$HOME/.share:\${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    AWS_SDK_LOAD_CONFIG = "1";
    GO111MODULE = "on";
    NIX_PATH = "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
    MANPAGER = "less -s -M +Gg";
  };
  programs.go.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    package = starship;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
    };
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    shellAliases = {
      du = "du -h";
      df = "df -h";
      ls = "${pkgs.exa}/bin/exa";
      ll = "ls -al";
    };
    initExtraBeforeCompInit = ''
    fpath+=("${profile}"/share/zsh/site-functions "${profile}"/share/zsh/$ZSH_VERSION/functions "${profile}"/share/zsh/vendor-completions ~/.local/share/zsh/site-functions)
  '';
  };
  home.file.".local/share/zsh/site-functions/_docker" = {
    source = "/Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion";
  };
  home.file.".local/share/zsh/site-functions/_docker-compose" = {
    source = "/Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion";
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.file.".doom.d" = {
    source = ./doom.d;
    recursive = true;
  };

  home.file.".Xdefaults".source = ./Xdefaults;

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Dave King";
    userEmail = "dave@davbo.uk";
    aliases = {
      pushf = "push --force-with-lease";
      l     = "log --oneline --graph --color";
    };
    extraConfig = {
      color = {
        ui = "true";
      };
    };
  };

  programs.home-manager = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPath = "/tmp/ssh-%u-%r@%h:%p";
    controlPersist = "1800";

    forwardAgent = true;

    hashKnownHosts = true;
    userKnownHostsFile = "~/.config/ssh/known_hosts";

    matchBlocks = {
      keychain = {
        host = "*";
        extraOptions = {
          UseKeychain = "yes";
          AddKeysToAgent = "yes";
          IgnoreUnknown = "UseKeychain";
        };
      };
    };
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    terminal = "screen-256color";
  };

  programs.vim = {
    enable = true;
    extraConfig = ''
      syntax enable
      set tabstop=2
      set number
      set hlsearch
      set incsearch
    '';
  };

  news.display = "silent";

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "david.king";
  home.homeDirectory = "/Users/david.king";
  home.stateVersion = "21.11";

  programs.bash = {
    enable = true;
    shellAliases = {
      du = "du -h";
      df = "df -h";
      ls = "${pkgs.exa}/bin/exa";
      ll = "ls -al";
    };
    profileExtra = ''
    # Source default profile
    if [ -f /etc/profile ] ; then
      . /etc/profile
    fi
    '';
    initExtra = ''
    # Get home-manager working
    export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH

    # Taken from https://metaredux.com/posts/2020/07/07/supercharge-your-bash-history.html
    # don't put duplicate lines or lines starting with space in the history.
    # See bash(1) for more options
    HISTCONTROL=ignoreboth

    # append to the history file, don't overwrite it
    shopt -s histappend
    # append and reload the history after each command
    PROMPT_COMMAND="history -a; history -n"

    # ignore certain commands from the history
    HISTIGNORE="ls:ll:cd:pwd:bg:fg:history"

    # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
    HISTSIZE=100000
    HISTFILESIZE=10000000
    '';
  };
}
