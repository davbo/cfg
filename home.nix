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
    extraPackages = epkgs: with epkgs; [ 
      use-package

      evil evil-collection evil-surround

      ivy counsel swiper

      magit 
    ];
  };

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
