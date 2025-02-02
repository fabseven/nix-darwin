{
	description = "NixOS Darwin";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		nix-darwin.url = "github:LnL7/nix-darwin";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = inputs@{ self, nix-darwin, nixpkgs }:
		let
			configuration = { pkgs, ... }: {
				# List packages installed in system profile. To search by name, run:
				# $ nix-env -qaP | grep wget
				environment.systemPackages = with pkgs;
					[ 
						vim
						neovim
						helix
						ruby_3_3
						fastfetch
						fish
						starship
						eza
						git
						go
						mas
						ranger
						tldr
						fzf
						tmux
						ripgrep
						jq
						rustup
						tree
						btop
						cmake
						chezmoi
						vscode
						emacs
						gh
						#zed-editor
					];

				# Auto upgrade nix package and the daemon service.
				services.nix-daemon.enable = true;
				nix.package = pkgs.nix;

				# Necessary for using flakes on this system.
				nix.settings.experimental-features = "nix-command flakes";

				# Exporting path
				environment.extraInit = ''
					export PATH=$HOME/bin:$PATH
				'';

				# Hostname stuff
				networking.hostName = "bibimbap";
				networking.computerName = "bibimbap";
				system.defaults.smb.NetBIOSName = "bibimbap";

				# Cleanup
				nix.gc.automatic = true;
				nix.settings.trusted-users = [ "root" "@admin" ];

				# Create /etc/zshrc that loads the nix-darwin environment.
				programs.zsh.enable = true;  # default shell on catalina
				programs.fish.enable = true;

				# Set Git commit hash for darwin-version.
				system.configurationRevision = self.rev or self.dirtyRev or null;

				# Used for backwards compatibility, please read the changelog before changing.
				# $ darwin-rebuild changelog
				system.stateVersion = 4;

				# The platform the configuration will be used on.
				nixpkgs.hostPlatform = "aarch64-darwin";

				nixpkgs.config.allowUnfree = true;

				security.pam.enableSudoTouchIdAuth = true;

				system.keyboard = {
					enableKeyMapping = true;
					remapCapsLockToControl = true;
					nonUS.remapTilde = true;
				};

				system.defaults = {
					dock = {
						autohide = true;
						mru-spaces = false;
						autohide-delay = 0.2;
						orientation = "left";
						showhidden = false;
						show-recents = false;
						tilesize = 31;
						wvous-br-corner = 1; #Disable default corner
					};
					finder = {
						ShowPathbar = true;
						ShowStatusBar = true;
						QuitMenuItem = true;
					};
					trackpad = {
						Clicking = true;
						TrackpadRightClick = true;
					};
					loginwindow.LoginwindowText = "kingdom";
					screencapture.location = "~/Pictures/screenshots";
					NSGlobalDomain = {
						AppleShowAllExtensions = true;
						NSAutomaticCapitalizationEnabled = false;
						NSAutomaticSpellingCorrectionEnabled = false;
						ApplePressAndHoldEnabled = false;
						"com.apple.mouse.tapBehavior" = 1;
						"com.apple.trackpad.enableSecondaryClick" = true;
						"com.apple.swipescrolldirection" = false;
						KeyRepeat = 2;
						InitialKeyRepeat = 15;
					};

					CustomUserPreferences = {
						"com.apple.desktopservices" = {
							DSDontWriteNetworkStores = true;
							DSDontWriteUSBStores = true;
						};
						"~/Library/Preferences/ByHost/com.apple.controlcenter".BatteryShowPercentage = true;

						"com.apple.AdLib".allowApplePersonalizedAdvertising = false;
					};
				};

				homebrew = {
					enable = true;
					onActivation = {
						autoUpdate = true;
					};
					casks = [
						"wireshark"
						"google-chrome"
						"firefox"
						"raycast"
						"vlc"
						"obsidian"
						"visual-studio-code"
						"font-jetbrains-mono"
						"font-jetbrains-mono-nerd-font"
						"font-geist-mono-nerd-font"
						"font-noto-color-emoji"
						"blackhole-2ch"
						"spotify"
						"steam"
						"zed"
						"nikitabobko/tap/aerospace"
						"discord"
						"hiddenbar"
						"iina"
						"linearmouse"
						"notion"
						"parsec"
						"powershell"
						"pritunl"
						"slack"
						"ticktick"
						"viscosity"
						"visual-studio-code"
						"wezterm"
						"obs"
						"microsoft-remote-desktop"
						"nvidia-geforce-now"
						"whisky"
						"telegram"
						"1password"
						"karabiner-elements"
						"vmware-fusion"
						"aldente"
						"microsoft-edge"
						"spacelauncher"
						"brave-browser"
						"ghostty"
					];
					brews = [
						"imagemagick"
						"starship"
						"fzf"
						"gh"
						"awscli"
						"dnsmasq"
						"tmux"
						"docker"
						"httpie"
					];
					masApps = {
						"Xcode" = 497799835;
						"amphetamine" = 937984704;
						"tailscale" = 1475387142;
					};
				};
				services.redis.enable = true;
			};
		in
			{
			# Build darwin flake using:
			# $ darwin-rebuild build --flake .#dk
			darwinConfigurations."dk" = nix-darwin.lib.darwinSystem {
				modules = [ configuration ];
			};

			# Expose the package set, including overlays, for convenience.
			darwinPackages = self.darwinConfigurations."dk".pkgs;
		};
}
