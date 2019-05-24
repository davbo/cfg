{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bash
    zsh

    coreutils
    findutils

    gnugrep
    gnused

    # Fonts
    fira-code
    fira-code-symbols
    source-code-pro
  ];

  programs.zsh = {
    enable = true;
    sessionVariables = {
      NIX_PATH = "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
      GOPATH = "$HOME/go";
      PATH = "$PATH:$HOME/.nix-profile/bin:$GOPATH/bin";
      _JAVA_AWT_WM_NONREPARENTING = 1;
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=10";
    };
    initExtra = ''
      autoload -Uz promptinit 
      promptinit
      . $HOME/.zsh/plugins/pure/pure.zsh
      . $HOME/.nix-profile/etc/profile.d/nix.sh
    '';
    plugins = [
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.5.2";
          sha256 = "1xhrdv6cgmq9qslb476rcs8ifw8i2vf43yvmmscjcmpz0jac4sbx";
        };
      }
      {
        name = "pure";
        file = "async.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev = "v1.9.0";
          sha256 = "0qimbksjn7w35wqfm40sjhwkx843m1szqmwlmw3xxf69yx1hyz6w";
        };
      }
    ];
  };

  programs.ssh.enable = true;
  programs.emacs.enable = true;
  home.file.".emacs.d" = {
    source = builtins.fetchGit {
      url = "https://github.com/syl20bnr/spacemacs";
      ref = "develop";
    };
    recursive = true;
  };
  home.file.".spacemacs".source = ./spacemacs.el;

  home.file.".Xdefaults".source = ./Xdefaults;

  programs.git = {
    enable = true;
    userName = "Dave King";
    userEmail = "dave@davbo.uk";
  };

  programs.home-manager = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
  };
}
