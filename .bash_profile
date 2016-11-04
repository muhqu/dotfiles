
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
        if [[ -n "$1" ]]; then
            export AWS_DEFAULT_PROFILE="$1"
            export AWS_PROFILE="$1"
            export AWS_REGION="$(aws configure get region 2>/dev/null || echo us-east-1)"
        else
            unset AWS_DEFAULT_PROFILE
            unset AWS_PROFILE
            unset AWS_REGION
            unset AWS_ACCESS_KEY_ID
            unset AWS_SECRET_ACCESS_KEY
            unset AWS_SESSION_TOKEN
        fi
    }
    __aws-profile() {
        local cur
        COMPREPLY=()   # Array variable storing the possible completions.
        cur=${COMP_WORDS[COMP_CWORD]}
        if [[ $COMP_CWORD -eq 1 ]]; then
            COMPREPLY=( $( compgen -W "$(awk -F '[\\]\\[ ]+' '/^\[/{print $2}' ~/.aws/credentials)" -- $cur ) )
        fi
        return 0
    }
    complete -F __aws-profile aws-profile

    aws-region() {
        if [[ -n "$1" ]]; then
            export AWS_DEFAULT_REGION="$1"
        else
            echo "$AWS_DEFAULT_REGION"
        fi
    }
    __aws-region() {
        local cur
        COMPREPLY=()   # Array variable storing the possible completions.
        cur=${COMP_WORDS[COMP_CWORD]}
        if [[ $COMP_CWORD -eq 1 ]]; then
            COMPREPLY=( $( compgen -W "us-east-1 us-west-2 eu-west-1 ap-northeast-1" -- $cur ) )
        fi
        return 0
    }
    complete -F __aws-region aws-region
fi

if which rbenv > /dev/null; then
    export RBENV_ROOT=/usr/local/var/rbenv
    eval "$(rbenv init -)";
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

