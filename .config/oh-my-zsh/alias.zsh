# TODO move all aliases here (K8s, Bun, etc.)

# development
alias zed="zeditor"
alias code="zeditor"
alias cg="~/Projects/clustergit/clustergit"
alias spacemacs="emacs"

# git
alias gstaf="ls | xargs -i sh -c 'echo _______ {} ______ && cd {} && git status -s -uno && cd ..'"

# package management
alias up="yay -Syu"
alias upf="up --overwrite '*'"

# VPN
alias mc="mullvad connect"
alias md="mullvad disconnect"

# system
alias sus="systemctl suspend"

# Bun
alias bl="bun lint"

# K8s
alias cilium="cilium-cli"
alias talos="talosctl"
