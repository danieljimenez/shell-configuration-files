# .bash_profile
# An interactive login shell (ie opening Terminal.app when on your mac)

# Source global definitions
if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

if [ -f ~/.secrets ]; then
	source ~/.secrets
fi

if [ `uname` = 'Linux' ]; then
	alias l.='ls -ld --color .*'
	alias ll='/bin/ls -lshG --color'
	alias ls='/bin/ls --color'
elif [ `uname` = 'Darwin' ]; then
	alias l.='ls -lGd .*'
	alias ll='/bin/ls -lshG'
	alias ls='/bin/ls -G'
	alias updatedb='/usr/libexec/locate.updatedb'
	alias xed='/usr/bin/xed -xc'
	alias rmate='/usr/local/bin/mate'
	alias notify='/usr/bin/osascript -e "display notification \"${*}\" sound name \"Blow\""'
	reveal () { open -R "$*"; }
fi

if [ -f /usr/local/bin/virtualenvwrapper_lazy.sh ]; then
	source /usr/local/bin/virtualenvwrapper_lazy.sh
fi

# if [ -f /usr/local/bin/docker-machine ]; then
# 	eval "$(docker-machine env default)"
# fi

if [ -s "$HOME/.rvm/scripts/rvm" ]; then
	source "$HOME/.rvm/scripts/rvm"
fi

##############Chef Aliases##################
alias berks='bundle exec berks'
alias chef='bundle exec chef'
alias knife='bundle exec knife'
alias kitchen='bundle exec kitchen'
alias ks='bundle exec knife status'

##############Environment Variables##################
export PATH=~/Applications:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH
export HISTCONTROL=ignoreboth
export HISTIGNORE="df:free:man:ls:ll:l.:reveal:gs:gl:open"
export HISTSIZE=75000
export FIGNORE=".DS_Store:.git/" #files to ignore with tab completion

if [ -f '/usr/local/bin/mate_wait' ]; then
	export EDITOR='/usr/local/bin/mate_wait'
fi

if [ -f /usr/libexec/java_home ]; then
	export JAVA_HOME=`/usr/libexec/java_home`
else 
	export JAVA_HOME='/usr/lib/jvm/jre'
fi

if [ `uname` = 'Darwin' ]; then
	if [ -f $(brew --prefix)/etc/bash_completion ]; then
		source $(brew --prefix)/etc/bash_completion
	fi
fi

if [ `uname` = 'Darwin' ]; then	
	if [ -f $(brew --prefix)/bin/aws_completer ]; then
		complete -C $(brew --prefix)/bin/aws_completer aws
	fi
fi


##############Command Completion##################
if [ `uname` = 'Darwin' ]; then	
	if [ -f `xcode-select -p`/usr/share/git-core/git-completion.bash ]; then
		source `xcode-select -p`/usr/share/git-core/git-completion.bash
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

		alias gf='git fetch --prune'
		__git_complete gf _git_fetch
		
		alias gco='git checkout'
		__git_complete gco _git_checkout
		
		alias gsu='git submodule update'
		__git_complete gsu _git_submodule update
		
		alias gt='cd $(git rev-parse --show-toplevel)'
		
		#These don't work bc of an off by one error in the git-complete code
		# alias gpush='git pull'
		# __git_complete gpull _git_pull
		#
		# alias gpush='git push'
		# __git_complete gpush _git_push
		
		alias gs='git status --short --branch'
	fi

	# git prompt additions
	if [ -f `xcode-select -p`/usr/share/git-core/git-prompt.sh ]; then
		source `xcode-select -p`/usr/share/git-core/git-prompt.sh
		export GIT_PS1_SHOWSTASHSTATE=true
		export GIT_PS1_SHOWDIRTYSTATE=true
		export GIT_PS1_SHOWCOLORHINTS=true
		export GIT_PS1_UNTRACKEDFILES=true
		Color_Off="\[\033[0m\]"
		Yellow="\[\033[0;33m\]"
		PROMPT_COMMAND_NEW='__git_ps1 "\h:\W" " \u${VIRTUAL_ENV:+($Yellow`basename $VIRTUAL_ENV`$Color_Off) }$ " "[%s]";'
		PROMPT_COMMAND="${PROMPT_COMMAND_NEW}${PROMPT_COMMAND}"
	fi
fi