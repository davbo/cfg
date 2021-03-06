{ pkgs, ... }:

let
  color_ps1 = "PS1='\${debian_chroot:+($debian_chroot)}\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '";
  plain_ps1 = "PS1='\${debian_chroot:+($debian_chroot)}\\u@\\h:\\w\\$ '";
in {
  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    idea.idea-community
    vscode
    awscli
    emacs
    fd
    ripgrep
    pandoc
    shellcheck
    google-cloud-sdk
    google-chrome
    wl-clipboard
    slack
    nodejs
    discord
    # Fonts
    fira-code
    fira-code-symbols
    source-code-pro
  ];

  home.sessionVariables = {
    PAGER = "less";
    EDITOR = "vim";
    PATH = "$PATH:/usr/local/go/bin:$HOME/.nix-profile/bin:$HOME/go/bin";
    GOPATH = "$HOME/go";
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$HOME/.share:\${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    AWS_SDK_LOAD_CONFIG = "1";
    DOOMLOCALDIR = "$HOME/.doom.d/.local";
    GO111MODULE = "on";
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      o  = "xdg-open";
      du = "du -h";
      df = "df -h";
      ls = "ls --color=tty";
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

    # Copied from Ubuntu's default bashrc
    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "''${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    # set a fancy prompt (non-color, unless we know we "want" color)
    case "$TERM" in
        xterm-color|*-256color) color_prompt=yes;;
    esac

    # uncomment for a colored prompt, if the terminal has the capability; turned
    # off by default to not distract the user: the focus in a terminal window
    # should be on the output of commands, not on the prompt
    #force_color_prompt=yes

    if [ -n "$force_color_prompt" ]; then
        if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
            # We have color support; assume it's compliant with Ecma-48
            # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
            # a case would tend to support setf rather than setaf.)
            color_prompt=yes
        else
            color_prompt=
        fi
    fi

    if [ "$color_prompt" = yes ]; then
        ${color_ps1}
    else
        ${plain_ps1}
    fi
    unset color_prompt force_color_prompt

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;''${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
    esac

    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
    # sources /etc/bash.bashrc).
    if ! shopt -oq posix; then
      if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
    fi

    '';
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  home.file.".emacs.d" = {
    source = builtins.fetchGit {
      url = "https://github.com/hlissner/doom-emacs";
      ref = "develop";
    };
    recursive = true;
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

  programs.ssh.enable = true;

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
}
