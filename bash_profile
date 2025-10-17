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
    # git top level, sneak to the top of the git repo
    alias gtl='cd $(git rev-parse --show-toplevel)'
    alias k='kubectl '
    alias ktail='kubectl get events --sort-by='.lastTimestamp' --watch'

    # show file in finder
    reveal() { open -R "${*:-.}"; }
    # generate a fun temporary password
    genpass() { curl -kSsL http://www.dinopass.com/password && echo ''; }
    # remove a line from the ssh known_hosts file
    rmknownhost() { sed -i.bak -e "$1d" ${HOME}/.ssh/known_hosts; }
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

# allows for multiple kube config files
export KUBECONFIG="$HOME/.kube/config:$(printf "%s " "$HOME/.kube"/conf.d/*.yaml | tr ' ' ':')"

# CotEditor
if [ -f '/usr/local/bin/cot' ]; then
    export EDITOR='cot -w'
fi

# Jetbrains Editor (idea)
if [ -d ~/Library/Application\ Support/JetBrains/Toolbox/scripts ]; then
    export PATH="~/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"
fi

# Docker
if [ -f /usr/local/bin/docker ]; then
  drm() { docker rm $(docker ps -a -q); }
  dri() { docker rmi $(docker images -q); }
  dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }
fi

## 1Password
#if [ -f ~/.config/op/plugins.sh ]; then
#    source ~/.config/op/plugins.sh
#fi

##############Command Completion##################
if [ $uname == 'Darwin' ]; then
    XCODE_PATH=$(xcode-select -p)
    eval "$(starship init bash)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
    if type brew &>/dev/null
    then
      HOMEBREW_PREFIX="$(brew --prefix)"
      if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
      then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
      else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
        do
          [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
        done
      fi
    fi

    alias k=kubectl
    complete -F __start_kubectl k

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

        alias gt='git tag'
        __git_complete gt _git_tag foreach

        #These don't work bc of an off by one error in the git-complete code
        # alias gpull='git pull'
        # __git_complete gpull _git_pull
        #
        # alias gpush='git push'
        # __git_complete gpush _git_push

        alias gs='git status --branch'

    fi

fi

