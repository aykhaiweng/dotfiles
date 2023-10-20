# OSX-only stuff. Abort if not OSX.
is_osx || return 1

e_arrow "Setting defaults for MacOS system"

# Remove press and hold for Mac cause Macshit
defaults write -g ApplePressAndHoldEnabled -bool false

# Disable animations when opening and closing windows.
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Disable animations when opening a Quick Look window.
defaults write -g QLPanelAnimationDuration -float 0

# Accelerated playback when adjusting the window size (Cocoa applications).
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Disable animation when opening the Info window in Finder (cmd⌘ + i).
defaults write com.apple.finder DisableAllAnimations -bool true

# Disable animations when you open an application from the Dock.
defaults write com.apple.dock launchanim -bool false

# Make all animations faster that are used by Mission Control.
defaults write com.apple.dock expose-animation-duration -float 0.1

# Disable the delay when you hide the Dock
defaults write com.apple.Dock autohide-delay -float 0

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles YES

# Remove that annoying .DS_Store file
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# Remove mouse scaling
defaults write .GlobalPreferences com.apple.mouse.scaling -1

# speed up Launchpad show and hide animations
defaults write com.apple.dock springboard-show-duration -float 0.1
defaults write com.apple.dock springboard-hide-duration -float 0.1

# speed up Launchpad page flip animation
defaults write com.apple.dock springboard-page-duration -float 0.1

# kill smooth swoosh animations
defaults write com.apple.dock workspaces-swoosh-animation-off -bool YES
