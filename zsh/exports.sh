# UTF-8 Encoding
export LC_ALL=pt_BR.UTF-8
export LANG=pt_BR.UTF-8
export LC_CTYPE=pt_BR.UTF-8
export LANGUAGE="pt_BR.UTF-8"

export EDITOR='nvim'

# Prompt
# autoload -U colors && colors
# PS1="[%n%{$fg[red]%}@%{$reset_color%}%m %~]\$ " #Red Hat style PS1

# Old PS1
# export PS1="[%n%{$fg[red]%}@%m %~]$ "

# Red and Blue PS1
# PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

# terminal colors
# eval $(dircolors -p | sed -e 's/DIR 01;34/DIR 01;36/' | dircolors /dev/stdin)

# NOTE: remove this, just use .local/bin
# user bin folder
# USR_BIN_DIR=$HOME/bin/
# if [ -d "$USR_BIN_DIR"  ]; then
#     export PATH="$HOME/bin/:$PATH"
# fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Export variables for Docker and Docker Compose
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)

# php composer
if [[ -d "$HOME/.config/composer/vendor/bin" ]]; then
    export PATH=$HOME/.config/composer/vendor/bin:$PATH
fi
#
# node
export PATH="$HOMEBREW_PREFIX/opt/node@22/bin:$PATH"

# Homebrew
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == "darwin25.0" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# bun completions
if [[ -d "$HOME/.bun/)bun" ]]; then
    source "$HOME/.bun/_bun"
fi

# linux Android
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    #TODO: arrumar o path do java
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
    export ANDROID_HOME=$HOME/Android/Sdk
    export PATH=$PATH:$ANDROID_HOME/emulator
    export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

# ruby
if [[ -d "$HOMEBREW_PREFIX/lib/ruby/gems/3.2.0/bin" ]]; then
    export PATH="$HOMEBREW_PREFIX/lib/ruby/gems/3.2.0/bin:$PATH"
fi

# ??
export PATH="$HOMEBREW_PREFIX/opt/binutils/bin:$PATH"

# zsh-autosuggestions
HISTFILE=~/.zsh_history
SAVEHIST=10000
setopt HIST_IGNORE_DUPS  # Don't save duplicate commands
setopt APPEND_HISTORY    # Add new history to the end of the file
setopt SHARE_HISTORY     # Share history between sessions
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=white,bold"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='bg=#d1d1d1,fg=#686868,bold'
# Load zsh-autosuggestions if it exists
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
