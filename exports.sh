# UTF-8 Encoding
# export LC_ALL=en_US.UTF-8
# export LANG=en_US.UTF-8
# export LC_CTYPE=en_US.UTF-8
# export LANGUAGE="en_US.UTF-8"

export EDITOR='vim'

# Prompt
# autoload -U colors && colors
# PS1="[%n%{$fg[red]%}@%{$reset_color%}%m %~]\$ " #Red Hat style PS1

# Old PS1
# export PS1="[%n%{$fg[red]%}@%m %~]$ "

# Red and Blue PS1
# PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

# terminal colors
# eval $(dircolors -p | sed -e 's/DIR 01;34/DIR 01;36/' | dircolors /dev/stdin)

# user bin folder
USR_BIN_DIR=$HOME/bin/
if [ -d "$USR_BIN_DIR"  ]; then
  export PATH="$HOME/bin/:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# rvm config
RVM_CONFIG_FILE=/etc/profile.d/rvm.sh
if [ -f "$RVM_CONFIG_FILE"  ]; then
  source $RVM_CONFIG_FILE
fi

# nvm config
NVM_DIR_TEST=$HOME/.nvm
if [ -d "$NVM_DIR_TEST"  ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# deno
DENO_DIR_TEST=$HOME/.deno
if [ -d "$NVM_DIR_TEST"  ]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# Imagem Magick Stuff
#export MAGICK_HOME="$HOME/opt/ImageMagick-6.9.1"
#export PATH="$MAGICK_HOME/bin:$PATH"
#export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib"

# Mysql
# export PATH=$PATH:"/usr/local/mysql/bin/"

# JAVA
#/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home/jre
# export JAVA_HOME=`/usr/libexec/java_home`
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

# Apache Maven
# export M1_HOME=$HOME/Projects/apache-maven-3.2.3
# export PATH=$PATH:$M1_HOME/bin

# Python
export PATH=$PATH:/usr/local/bin/python

# ANDROID
export PATH="$PATH:$HOME/Dev/libs/flutter/bin"
export PATH="$PATH:$HOME/Android/Sdk"
export ANDROID_HOME=$HOME/Android
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Export variables for Docker and Docker Compose
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)

emulate sh -c 'source /etc/profile.d/apps-bin-path.sh'

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ssl + sqlserver
export PATH="$PATH:/opt/mssql-tools18/bin"
export OPENSSL_CONF=/etc/ssl/openssl.cnf

