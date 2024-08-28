if status is-interactive
    # Commands to run in interactive sessions can go here
    alias ndw="nix run nix-darwin -- switch --flake ~/.config/nix-darwin"
    alias drb="darwin-rebuild switch --flake ~/.config/nix-darwin"
	  alias ls="eza -l --git -a"
	  alias mkdir="mkdir -p"
	  alias vim="nvim"
	  set -x NIX_CONF_DIR $HOME/.config/nix
end
starship init fish | source
