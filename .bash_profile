
for file in ~/.bash_{extra,functions,prompt,exports,alias}; do
    [ -r "$file" ] && source "$file"
done; unset file

if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

if [ -f ~/.bash_complete_mvn ]; then
    . ~/.bash_complete_mvn
fi

if [ -f /usr/local/go/misc/bash/go ]; then
    . /usr/local/go/misc/bash/go
fi

if [ -f ~/.iterm2_shell_integration.bash ]; then
    env | grep ITERM >/dev/null && . ~/.iterm2_shell_integration.bash
fi

if [ -n "$(which aws_completer)" ]; then
    complete -C aws_completer aws

	aws-profile() {
		export AWS_DEFAULT_PROFILE="$1"
	}

fi

if which rbenv > /dev/null; then
    export RBENV_ROOT=/usr/local/var/rbenv
    eval "$(rbenv init -)";
fi
