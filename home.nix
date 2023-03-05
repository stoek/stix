{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "stan";
  home.homeDirectory = "/home/stan";
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;


  home.packages = with pkgs; [
    htop
    exa
    openvpn
    neovim
  ];

programs.neovim.extraConfig = lib.fileContents ./config/nvim/init.vim;

programs.zsh = {
  enable = true;
  enableSyntaxHighlighting = true;
  shellAliases = {
    la = "exa -a --group-directories-first";
    lal = "exa -la --group-directories-first";
    lsl = "exa -l --group-directories-first";
    ls = "exa --group-directories-first";
    cl = "clear";
    norb = "sudo nixos-rebuild switch --flake /home/stan/.stix";
    nogb = "sudo nix-collect-garbage";
    nsn = "echo $NSNAME";
  };
  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
  };
  zplug = {
    enable = true;
    plugins = [
      { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
    ];
  };

  initExtra = ''
    setprompt() {
    setopt prompt_subst
    if [[ -v IN_NIX_SHELL ]]; then
        PROMPT='%T %~
    %F{yellow}% $(nsn) %F{red}%\:%F{green}%\:%F{blue}%\:%F{magenta}%\:%f '
    else 
        PROMPT='%T %~
    %F{red}%\:%F{green}%\:%F{yellow}%\:%F{blue}%\:%F{magenta}%\:%f '
    fi
    }
    
    setprompt
    eval "$(direnv hook zsh)"
    export DIRENV_LOG_FORMAT=
    chpwd_functions+=(setprompt)
  '';
};

}
