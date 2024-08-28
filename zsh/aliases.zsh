# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# Filesystem aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Helpers
alias grep='grep --color=auto'
alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

alias lpath='echo $PATH | tr ":" "\n"' # list the PATH separated by new lines

# Applications
alias ios='open -a /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app'

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"
# remove broken symlinks
alias clsym="find -L . -name . -o -type d -prune -o -type l -exec rm {} +"

# use eza if available
if [[ -x "$(command -v eza)" ]]; then
  alias ll="eza --icons --git --long"
  alias l="eza --icons --git --all --long"
  alias lt="eza --tree --level=2 --long --icons --git"
else
  alias l="ls -lah ${colorflag}"
  alias ll="ls -lFh ${colorflag}"
fi

alias la="ls -AF ${colorflag}"
alias lld="ls -l | grep ^d"

alias rmf="rm -rf"

# tmux aliases
alias ta='tmux attach'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'

alias vim="nvim"
alias vi="nvim"

# Kickstart Nvim
alias ks='NVIM_APPNAME="nvim-kickstart" nvim'

# JayakornK Nvim
alias jk='NVIM_APPNAME="nvim-jayakornk" nvim'
