{
    enable = true;
    terminal = "tmux-256color";
    shortcut = "q";
    keyMode = "vi";
    historyLimit = 10000;
    escapeTime = 10;
    clock24 = true;
    extraConfig = builtins.readFile ./tmux.conf;
}
