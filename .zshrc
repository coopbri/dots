# https://old.reddit.com/r/zsh/comments/ltcacs/zsh_error_character_not_in_range/
export LC_ALL=en_US.UTF-8

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

POWERLEVEL9K_MODE="nerdfont-complete"

# path to oh-my-zsh installation
ZSH=/usr/share/oh-my-zsh/

# zsh theme
# ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(colored-man-pages git poetry nvm ssh-agent zsh-autosuggestions zsh-syntax-highlighting helm you-should-use $plugins)
# plugins=(...dotenv)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

function mkcd {
  last=$(eval "echo \$$#")
  if [ ! -n "$last" ]; then
    echo "Enter a directory name"
  elif [ -d $last ]; then
    echo "\`$last' already exists"
  else
    mkdir $@ && cd $last
  fi
}

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

# Oh-My-ZSH
source $ZSH/oh-my-zsh.sh

# Powerlevel10k theme (AUR)
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

eval $(thefuck --alias)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_first_and_last
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

alias yay="paru"

alias x="pkgx"

alias pullaf="ls | xargs -P10 -I{} git -C {} pull"

# git
# alias git="gix"

# Vim
alias v="nvim"

# Arch Linux
alias yay-skip-valid="yay -S --mflags --skipinteg"

# Android
ANDROID_SDK=/home/brian/Android/SDK

alias diff="colordiff"
alias cat="bat"

# JavaScript / TypeScript
alias y="yarn"
alias yd="y dev"
alias yb="y build"
alias ys="y start"
alias yt="y test"
alias yup="y up '**'"
alias tsnd="ts-node-dev"
alias b="bun"
alias bi="b i"
alias bd="b dev"
alias bb="b run build"
alias bs="bun start"
alias bt="bun run test"
alias btw="bun run test:watch"
alias br="bun run"
alias bx="bunx"
# TODO replace this once https://github.com/oven-sh/bun/issues/1372 in place
alias bup="bx npm-check-updates -ui"

# Rust
alias c="cargo"
alias cc="cargo check"
alias cb="cargo build"
alias cr="cargo run"
alias cw="cargo watch"
alias ct="cargo test"
alias rust="rust-script"
alias rs="rust-script"

# React Native
alias rndoctor="npx @react-native-community/cli doctor"

# Prisma
alias prisma="npx prisma"
alias mg="migrate"
alias pmgs="prisma migrate save --experimental"
alias pmgu="prisma migrate up --experimental"
alias pgen="prisma generate"
alias yeet="sudo kill -9"

alias bleach="bleachbit -c --preset"

alias tf="terraform"

alias p="pulumi"

# Gaming
alias runescape="runescape-launcher"

# Docker/Kubernetes
alias d="docker"
alias d-c="docker-compose"
alias k="kubectl"
alias mk="minikube"
alias kctx="kubectx"
alias kns="kubens"

# Tilt
alias t="tilt"
alias tup="tilt up"

# R
alias r="Rscript"

alias mine="~/Data/Cloud/Nextcloud/scripts/ethminer.sh"

alias cfg="/usr/bin/git --git-dir=$HOME/.dots --work-tree=$HOME"

[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

export YVM_DIR=/home/brian/.yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

# bit
export PATH="$PATH:/home/brian/bin"
# bit end

# Created by `pipx` on 2022-08-05 23:02:56
#export PATH="$PATH:/home/brian/.local/bin"
#export PATH="/opt/brew/bin:$PATH"
#export PATH="/opt/brew/sbin:$PATH"


eval "$(starship init zsh)"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/brian/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

export PNPM_HOME="/home/brian/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

export PATH="$PATH:/home/brian/.foundry/bin"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/mcli mcli
