export PATH=$HOME/local/bin:$PATH

if [ -f /opt/local/etc/bash_completion ]; then
	. /opt/local/etc/bash_completion
fi

PATH=$PATH:$HOME/.rvm/bin:/usr/local/go/bin
