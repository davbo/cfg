{ config, pkgs, ... }:

let profile = "${config.home.profileDirectory}";
in {
  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."home-manager/config.nix".source = ./nixpkgs-config.nix;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # utils
    bashInteractive
    coreutils-prefixed
    fd
    ripgrep
    shellcheck
    nixfmt
    plantuml
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science fi ]))
    exa
    openssl_3
    jq
    sqlite
    gnumake
    pyright
    nodePackages_latest.mermaid-cli
    # cloud stuff
    awscli2
    ssm-session-manager-plugin
    kubectl
    kubectx
    kubernetes-helm
    eksctl
    google-cloud-sdk
    terraform
    xz
    dive
    ipcalc
    pgcli
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
    PATH =
      "/nix/var/nix/profiles/default/bin:/usr/local/go/bin:$HOME/.nix-profile/bin:$HOME/go/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
    GOPATH = "$HOME/go";
    XDG_DATA_DIRS =
      "$HOME/.nix-profile/share:$HOME/.share:\${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}";
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
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = { add_newline = false; };
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
      setopt interactivecomments
      fpath+=("${profile}"/share/zsh/site-functions "${profile}"/share/zsh/$ZSH_VERSION/functions "${profile}"/share/zsh/vendor-completions ~/.local/share/zsh/site-functions)
    '';
    initExtra = ''
      source <(kubectl completion zsh)
    '';
  };
  home.file.".local/share/zsh/site-functions/_docker" = {
    source =
      "/Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion";
  };
  home.file.".local/share/zsh/site-functions/_docker-compose" = {
    source =
      "/Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion";
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
    userEmail = "dave@davbo.fi";
    aliases = {
      pushf = "push --force-with-lease";
      l = "log --oneline --graph --color";
      s = "status";
    };
    extraConfig = { color = { ui = "true"; }; };
  };

  programs.home-manager = { enable = true; };

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
    historySize = 1000000;
    shellAliases = {
      du = "du -h";
      df = "df -h";
      ls = "${pkgs.exa}/bin/exa";
      ll = "ls -al";
    };
    historyIgnore = [ "ls" "cd" "exit" "ll" "pwd" "bg" "fg" "history" ];
  };
}
