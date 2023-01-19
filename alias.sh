# Alias
# ============================================================================>
alias c="clear"
alias cls="clear"
alias vim="nvim"
alias ovim="vim"
alias vi="nvim"
alias ls='ls -G --color=auto'
alias ll="ls -ls --color=auto"
alias llm="ls -lsh --color=auto"
alias la="ls -la --color=auto"
alias lla="ls -la --color=auto"
alias more="less"

# git
alias giff="git diff $1^!"

# rails/ruby
alias rs="rails s"
alias rc="rails console"
alias rmigrate="rake db:drop && rake db:create && rake db:migrate && rake db:seed"
alias killruby='killall -9 ruby'
alias killrudy='killruby'
alias kr="killruby"

#docker stuff
alias dll="docker container ls"
alias dlli="docker image ls"
alias dstop="docker container stop"
alias rmdoc="docker container rm"

# windows WSL, linus and mac (WIP)
alias open='dolphin .'

# Laravel
alias artisan="php artisan"
alias art="artisan"
alias dbreset="php artisan migrate:fresh --seed"
alias dbseed="dbreset"
alias lseed="dbreset"
alias tinker="php artisan tinker"
alias laraserve="php artisan serve"
alias ltest="php artisan test"
alias lserve="laraserve"
alias lmigrate="php artisan migrate"
alias laramigrate="lmigrate"
alias lroute="php artisan route:list"
