{ config, pkgs, ... }:

{
  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";

    # link the configuration file in current directory to the specified location in
    # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;
    file.".emacs.d/init.el".source = ./home/.emacs.d/init.el;

    # link all files in `./scripts` to `~/.config/i3/scripts`
    # home.file.".config/i3/scripts" = {
    #   source = ./scripts;
    #   recursive = true;   # link recursively
    #   executable = true;  # make all files executable
    # };

    # encode the file content in nix configuration file directly
    # home.file.".xxx".text = ''
    #     xxx
    # '';

    # set cursor size and dpi for 4k monitor
    # xresources.properties = {
    #   "Xcursor.size" = 16;
    #   "Xft.dpi" = 172;
    # };

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      # here is some command line tools I use frequently
      # feel free to add your own or remove some of them
    ];
  };

  # basic configuration of git, please change to your own
  programs = {
    git = {
      enable = true;
      userName = "Noppi";
      userEmail = "noppi@noppi.jp";
      extraConfig = {
        push.default = "nothing";
      };
    };

    neovim = {
      enable = true;
      extraConfig = ''
        colorscheme vim
        set expandtab
        set ignorecase
        set number
        set shiftwidth=0
        set showmatch
        set smartcase
        set smartindent
        set tabstop=4
        set termguicolors

        set ambiwidth=double
        set fileencodings=ucs-bom,utf-8,iso-2022-jp,sjis,euc-jp,cp932,utf-16le,default,laten1
      '';
    };

    # vscode = {
    #   enable = true;
    #   profiles.default.extensions = with pkgs.vscode-extensions; [
    #     ms-vscode-remote.remote-containers
    #     asvetliakov.vscode-neovim
    #     ms-ceintl.vscode-language-pack-ja
    #   ];
    # };
  };

  # This value determines the home Manager release that your
  # configuration is compmatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";
}
