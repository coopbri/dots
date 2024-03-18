export DOTNET_CLI_TELEMETRY_OPTOUT=1
# export PATH="/home/brian/.ebcli-virtual-env/executables:$PATH"
export PATH=$PATH:~/.npm-global/bin
export PATH=$PATH:~/.cargo/bin
export PATH=$PATH:~/.node_modules/bin
export PATH=$PATH:~/Data/Cloud/Nextcloud/scripts
# export PATH="${PATH}:${HOME}/.krew/bin"
export PATH=$PATH:$HOME/.krew/bin
export PATH=$PATH:$HOME/.local/share/solana/install/active_release/bin

export EDITOR=vim

export FE_PATH="/usr/bin/fe"

# Required for Android sdkmanager (for Flutter, check this later)
export JAVA_HOME="/usr/lib/jvm/default"
export ANDROID_HOME="/opt/android-sdk"
export NDK_HOME="/opt/android-ndk"
export ANDROID_SDK_ROOT="/opt/android-sdk"

export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"

# Enable Plasma QT scaling (experimental, not sure if this works well)
# TODO try setting global display scale to 100% too
PLASMA_USE_QT_SCALING=1

# https://github.com/nodejs/help/issues/1887#issuecomment-1537081657
export NODE_OPTIONS="--dns-result-order=ipv4first"
