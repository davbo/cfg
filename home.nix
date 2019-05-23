{ pkgs, ... }:

{
  home.packages = [
    pkgs.htop
    pkgs.jetbrains.idea-community
  ];

  programs.alacritty = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    sessionVariables = {
      GOPATH = "$HOME/go";
      PATH = "$PATH:$GOPATH/bin";
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };
  };

  programs.emacs = {
    enable = true;
  };
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
