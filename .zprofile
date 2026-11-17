# Solana CLI, only where it is installed
[[ -d $HOME/.local/share/solana/install/active_release/bin ]] && export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# Start Hyprland on TTY1
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec start-hyprland
fi
