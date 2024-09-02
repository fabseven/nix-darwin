if status is-interactive
    # Commands to run in interactive sessions can go here
    alias ndw="nix run nix-darwin -- switch --flake ~/.config/nix-darwin"
    alias drb="darwin-rebuild switch --flake ~/.config/nix-darwin"
	  alias ls="eza -l --git -a"
	  alias mkdir="mkdir -p"
	  alias vim="nvim"
	  set -x NIX_CONF_DIR $HOME/.config/nix
	  set -Ua fish_user_paths $HOME/.local/bin
end
starship init fish | source
