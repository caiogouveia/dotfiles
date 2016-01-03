autoload -U colors && colors
# Prompt
PS1="[%n%{$fg[red]%}@%{$reset_color%}%m %~]\$ " #Red Hat style PS1

# Old PS1
# export PS1="[%n%{$fg[red]%}@%m %~]$ "

# Red and Blue PS1
# PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "


# Prompt
PS1="[%n%{$fg[red]%}@%{$reset_color%}%m %~]\$ " #Red Hat style PS1

# Old PS1
# export PS1="[%n%{$fg[red]%}@%m %~]$ "

# Red and Blue PS1
# PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

# bin directories Path
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
# export MANPATH="/usr/local/man:$MANPATH"

# Imagem Magick Stuff
# versão atual
#export MAGICK_HOME="$HOME/opt/ImageMagick-6.9.1"
#export PATH="$MAGICK_HOME/bin:$PATH"
#export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib"

# Mysql lib
export PATH=$PATH:"/usr/local/mysql/bin/"

# JAVA
#/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home/jre
export JAVA_HOME=`/usr/libexec/java_home` 

# RVM
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
