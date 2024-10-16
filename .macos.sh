## Finder

# Hide the desktop icons (specifically folders)
#
# This disables clicking the wallpaper to minimize the current windows in Stage Manager.
defaults write com.apple.finder CreateDesktop -bool false

# Show Quit menu item.
defaults write com.apple.finder QuitMenuItem -bool true

## Window

# Disable hovering the zoom button to display a menu with window arrangement options (e.g. tiling)
defaults write -g NSZoomButtonShowMenu false

## Focus

# Disable the focus ring animating when switching controls.
defaults write NSGlobalDomain NSUseAnimatedFocusRing false

## Safari

# Use "Contains" instead of "Begins with" when searching for words on pages by default
sudo defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly false

## Dock

# Disable the delay when hovering the mouse at the edge of the screen for the dock
#
# This does not apply in full screen mode.
defaults write com.apple.dock autohide-delay -int 0

## Relaunch processes

killall Finder
killall Safari
killall Dock
