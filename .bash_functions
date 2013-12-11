#!/bin/bash

#
# generic functions specific
# -----------------------------------------------------------------------------

function callonchange() {
    WATCH_PATH="$1"
    shift 1
    [ "X" = "X$WATCH_PATH" -o "X" = "X$*" ] \
        && echo "Usage: callonchange <path/to/watach> <exec-statement>" \
        || while true; do \
              echo "$@" | bash; \
              echo "___"; \
              echo "waiting for change in $WATCH_PATH to execute: $@"; \
              wait4change $WATCH_PATH; \
           done;
}

function highlight() {
    WHAT="${1:-error}"
    STYLE="${2:-7}"
    CODE='$S=$argn;';
    until [ -z "$1" ]; do
        WHAT="${1:-error}";
        STYLE="${2:-7}";
        shift; shift;
        CODE=$CODE'$S=preg_replace("/(.*)(\w*'$WHAT'\w*)(.*)/i","\x1b['$STYLE'm\\1\x1b['$STYLE';1m\\2\x1b[0m\x1b['$STYLE'm\\3\x1b[0m",$S);'
    done
    CODE=$CODE'print $S.PHP_EOL;';
    php -R "$CODE";
}

function taillog() {
    LOG="$@"
    if [ -z "$LOG" ]; then 
        LOG="/var/log/system.log"
    fi
    tail -f "$LOG" | highlight fatal '31;7' err 31 warn 35 notice 36
}

function sshscr() {
   # launch a sreen-session over SSH
   ssh $* -t screen -R -D -T xterm-color -e '^Yy'
}

function reldate() {
    php -r 'date_default_timezone_set("Europe/Berlin"); print date(DATE_RFC2822,strtotime("'"$*"'")).PHP_EOL;'
}

#
# e.g. seq 0 40 | awk '{printf "%d\n", (sin($1/4)*cos($1/2)+1)*20;}' | superspark
#
function superspark() {
    (test -t 0 && echo "$@" || cat) \
    | xargs -n1 \
    | php -r '
        $S=array_map("intval",file("php://stdin"));
        $M=array_reduce($S, "max", 0);
        $R=array_map(function($I) use ($M) {
            return $I/$M;
        }, $S);
        print str_repeat("\n",3).implode(array_map(function($F){
            return json_decode("\" ".str_repeat("\u0304", max(1,ceil($F*19)))."\"");
        }, $R), "")."\n";
        '
}

#
# Mac OS X specific
# -----------------------------------------------------------------------------

if [[ $(uname -s) == "Darwin" ]]; then

function tab {
    # open a new tab on Terminal with the current working dir
    osascript -e "
        tell application \"System Events\" to tell process \"Terminal\" to keystroke \"t\" using command down
        tell application \"Terminal\" to do script \"cd $PWD \" in selected tab of the front window
    " > /dev/null 2>&1
}

function win {
    # open a new Terminal Window with the current working dir
    osascript -e "
        tell application \"System Events\" to tell process \"Terminal\" to keystroke \"n\" using command down
        tell application \"Terminal\" to do script \"cd $PWD \" in selected tab of the front window
    " > /dev/null 2>&1
}

function chrome-reload {
    # soft-reloads the active tab of Google Chrome by focusing the location field and hiting return
    osascript -e "
    tell application \"Google Chrome\"
        activate
        tell application \"System Events\"
            tell process \"Google Chrome\"
                delay 0.1
                keystroke \"l\" using command down
                delay 0.1
                keystroke return
            end tell
        end tell
    end tell
    " > /dev/null 2>&1
}

function chrome-shift-reload {
    # hard-reloads the active tab of Google Chrome by pressing cmd+shift+r
    osascript -e "
    tell application \"Google Chrome\"
        activate
        tell application \"System Events\"
            tell process \"Google Chrome\"
                delay 0.1
                keystroke \"r\" using {command down, shift down}
                delay 0.1
            end tell
        end tell
    end tell
    " > /dev/null 2>&1
}

function last-active-app {
    # returns to last active application, e.g. use: chrome-reload && last-active-app
    osascript -e "tell application \"System Events\" to keystroke tab using command down" > /dev/null 2>&1
}

function cmd-c {
    # copy to clipboard
    osascript -e "tell application \"System Events\" to keystroke \"c\" using command down" > /dev/null 2>&1
}

function cmd-v {
    # paste from clipboard
    osascript -e "tell application \"System Events\" to keystroke \"v\" using command down" > /dev/null 2>&1
}

function paste-password {
    CLPBRD="/tmp/.old-clipboard";
    pbpaste > $CLPBRD;
    security 2>&1 >/dev/null find-generic-password -gs "$@" \
     | awk '/password/{printf "%s", substr($0,12,length($0)-12)}' \
     | pbcopy \
    && sleep 1s \
    && cmd-v \
    && cat $CLPBRD | pbcopy \
    && rm $CLPBRD
}

fi # if Darwin