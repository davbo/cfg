{ pkgs, ... }:

{
  home.packages = [
    pkgs.htop
  ];

  programs.alacritty = {
    enable = true;
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
