# UTF-8 Encoding
# ===========================================================================>
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Prompt
# ===========================================================================>
autoload -U colors && colors
PS1="[%n%{$fg[red]%}@%{$reset_color%}%m %~]\$ " #Red Hat style PS1

# Old PS1
# export PS1="[%n%{$fg[red]%}@%m %~]$ "

# Red and Blue PS1
# PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

# Bin Directories to the Path
# ===========================================================================>
# export MANPATH="/usr/local/man:$MANPATH"
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
export PATH=$PATH:"/Developer/usr/bin"
export PATH=$PATH:"~/bin"

# Imagem Magick Stuff
# ===========================================================================>
#export MAGICK_HOME="$HOME/opt/ImageMagick-6.9.1"
#export PATH="$MAGICK_HOME/bin:$PATH"
#export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib"

# Mysql
# ===========================================================================>
export PATH=$PATH:"/usr/local/mysql/bin/"

# JAVA
# ===========================================================================>
#/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home/jre
export JAVA_HOME=`/usr/libexec/java_home` 

# Apache Maven
# ===========================================================================>
export M2_HOME=$HOME/Projects/apache-maven-3.2.3
export PATH=$PATH:$M2_HOME/bin

# RVM
# ===========================================================================>
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
