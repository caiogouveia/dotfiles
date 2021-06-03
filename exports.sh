# UTF-8 Encoding
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Prompt
# autoload -U colors && colors
# PS1="[%n%{$fg[red]%}@%{$reset_color%}%m %~]\$ " #Red Hat style PS1

# Old PS1
# export PS1="[%n%{$fg[red]%}@%m %~]$ "

# Red and Blue PS1
# PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

# terminal colors
eval $(dircolors -p | sed -e 's/DIR 01;34/DIR 01;36/' | dircolors /dev/stdin)

# user bin folder
USR_BIN_DIR=$HOME/bin/
if [ -d "$USR_BIN_DIR"  ]; then
  export PATH="$HOME/bin/:$PATH"
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

# Imagem Magick Stuff
#export MAGICK_HOME="$HOME/opt/ImageMagick-6.9.1"
#export PATH="$MAGICK_HOME/bin:$PATH"
#export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib"

# Mysql
# export PATH=$PATH:"/usr/local/mysql/bin/"

# JAVA
#/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home/jre
# export JAVA_HOME=`/usr/libexec/java_home` 

# Apache Maven
# export M2_HOME=$HOME/Projects/apache-maven-3.2.3
# export PATH=$PATH:$M2_HOME/bin


