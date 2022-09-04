# Alias
# ============================================================================>
alias c="clear"
alias cls="clear"
alias vim="nvim"
alias ovim="vim"
alias ls='ls -G --color=auto'
alias ll="ls -ls --color=auto"
alias llm="ls -lsh --color=auto"
alias la="ls -la --color=auto"
alias lla="ls -la --color=auto"
alias more="less"

# rails/ruby
alias rs="rails s"
alias rc="rails console"
alias rmigrate="rake db:drop && rake db:create && rake db:migrate && rake db:seed"
alias killruby='killall -9 ruby'
alias killrudy='killruby'
alias kr="killruby"

# windows WSL
alias open='powershell.exe /c start'

# Laravel
alias artisan="php artisan"
alias art="artisan"
alias dbreset="php artisan migrate:fresh --seed"
alias dbseed="dbreset"
alias lseed="dbreset"
alias tinker="php artisan tinker"
alias laraserve="php artisan serve"
alias lserve="laraserve"
alias lmigrate="php artisan migrate"
alias laramigrate="lmigrate"
alias lroute="php artisan route:list"
