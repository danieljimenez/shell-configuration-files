#!/usr/bin/env bash
# .bash_profile

# Source global definitions
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ -f ~/.bash_profile_work ]; then
    source ~/.bash_profile_work
fi

if [ -f ~/.secrets ]; then
    source ~/.secrets
fi

uname=$(uname)

if [ $uname == 'Darwin' ]; then
    alias l.='/bin/ls -Glsha'
    alias ll='/bin/ls -Glsh'
    alias ls='/bin/ls -G'
    alias tf='terraform'
    alias xed='/usr/bin/xed -xc'
    alias rmate='/usr/local/bin/mate'
    alias hb='hub browse'
    alias gt='gittower $(git rev-parse --show-toplevel)'
    alias gtl='cd $(git rev-parse --show-toplevel)' # Sneak to the top of the git repo
    alias kg='kubectl get '
    reveal() { open -R "${*:-.}"; }
    genpass() { curl -SsL http://www.dinopass.com/password && echo ''; }
    ssh-known-host-delete-line() { sed -i.bak -e "$1d" ${HOME}/.ssh/known_hosts; }
elif [ $uname == 'Linux' ]; then
    alias l.='ls -ld --color'
    alias ll='/bin/ls -lshG --color'
    alias ls='/bin/ls --color'
fi

##############Environment Variables##################
export PATH="${HOME}/Applications:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
export MANPATH="/opt/local/share/man:$MANPATH"
export HISTCONTROL="ignoreboth"
export HISTIGNORE="df:free:man:ls:ll:l.:reveal:gs:gl:open"
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
export FIGNORE=".DS_Store:.git/" # files to ignore with tab completion
export GOPATH="${HOME}/src/golang" # go workspace

# Ruby stuff
if [ -f  "$HOME/.rvm/scripts/rvm" ]; then
    source "$HOME/.rvm/scripts/rvm"
fi

# CotEditor
if [ -f '/usr/local/bin/cot' ]; then
    export EDITOR='cot -w'
fi

# # Sublime Editor
# if [ -f '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' ]; then
#     export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
#     export EDITOR='subl -w'
# fi

# Docker
if [ -f /usr/local/bin/docker ]; then
  drm() { docker rm $(docker ps -a -q); }
  dri() { docker rmi $(docker images -q); }
  dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }
fi

# 1Password
if [ -f ~/.config/op/plugins.sh ]; then
    source ~/.config/op/plugins.sh
fi

##############Command Completion##################
if [ $uname == 'Darwin' ]; then
    XCODE_PATH=$(xcode-select -p)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
    # AWS
    if [ -f "/usr/local/bin/aws_completer" ]; then
        if [ -f /usr/local/bin/aws_completer ]; then
            complete -C /usr/local/bin/aws_completer aws
        fi
    fi

    # GCloud
    if [ -f '/usr/local/google-cloud-sdk/completion.bash.inc' ]; then
        source '/usr/local/google-cloud-sdk/completion.bash.inc'
    fi

    # RVM
    if [ -f  "$HOME/.rvm/scripts/rvm" ]; then
        source "$HOME/.rvm/scripts/rvm"
    fi

    # bash completion
    # Large impact on shell open time.
    if [ -f ${BREW_PATH}/etc/bash_completion ]; then
        source ${BREW_PATH}/etc/bash_completion
    fi

    # git prompt additions and shortcuts
    if [ -f "${XCODE_PATH}/usr/share/git-core/git-completion.bash" ]; then
        source "${XCODE_PATH}/usr/share/git-core/git-completion.bash"
        
        # These are command completion mappings for the above images.
        alias g='git'
        __git_complete g __git_main
        
        alias ga='git add'
        __git_complete ga _git_add
        
        alias gb='git branch'
        __git_complete gb _git_branch
        
        alias gd='git diff'
        __git_complete gd _git_diff
        
        alias gc='git commit'
        __git_complete gc _git_commit
        
        alias gl='git log --name-status'
        __git_complete gl _git_log
        
        alias gr='git reset'
        __git_complete gr _git_reset

        alias gfp='git fetch --prune --all && git pull'
        alias gf='git fetch --prune --all'
        __git_complete gf _git_fetch
        
        alias gco='git checkout'
        __git_complete gco _git_checkout
        
        alias gsu='git submodule update --init --recursive'
        __git_complete gsu _git_submodule update
    
        alias gsf='git submodule foreach --recursive'
        __git_complete gsu _git_submodule foreach
        
        #These don't work bc of an off by one error in the git-complete code
        # alias gpull='git pull'
        # __git_complete gpull _git_pull
        #
        # alias gpush='git push'
        # __git_complete gpush _git_push
        
        alias gs='git status --branch'
    fi
    
fi

