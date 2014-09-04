
for file in ~/.bash_{extra,functions,prompt,exports,alias}; do
    [ -r "$file" ] && source "$file"
done; unset file


if [ -s ~/.rvm/scripts/rvm ]; then
    . ~/.rvm/scripts/rvm # Load RVM into a shell session *as a function*
fi

if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

if [ -f /usr/local/go/misc/bash/go ]; then
	. /usr/local/go/misc/bash/go
fi

if [ -f ~/.iterm2_shell_integration.bash ]; then
	. ~/.iterm2_shell_integration.bash
fi
