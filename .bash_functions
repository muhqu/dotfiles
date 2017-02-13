#!/bin/bash

#
# generic functions specific
# -----------------------------------------------------------------------------

json2yml() {
  python -c 'import sys,json,yaml;yaml.safe_dump(json.load(sys.stdin),sys.stdout,allow_unicode=True)'
}

yml2json() {
  python -c 'import sys,json,yaml;json.dump(yaml.load(sys.stdin),sys.stdout,ensure_ascii=False,indent=2)'
}

until-it-works() {
  while true; do
    echo $'\033'"[33m>> $@"$'\033'"[0m";
    "$@" && break
    sleep 20
  done
}

callonchange() {
    WATCH_PATH="$1"
    shift 1
    [ "X" = "X$WATCH_PATH" -o "X" = "X$*" ] \
        && echo "Usage: callonchange <path/to/watach> <exec-statement>" \
        || while true; do \
              echo ". ~/.bash_profile;" "$@" '; [ $? -ne 0 ] && iterm-bgcolor 33000 || iterm-bgcolor 00000' | bash; \
              echo "___"; \
              echo "waiting for change in $WATCH_PATH to execute: $@"; \
              wait4change $WATCH_PATH; \
           done;
}

highlight() {
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

taillog() {
    LOG="$@"
    if [ -z "$LOG" ]; then 
        LOG="/var/log/system.log"
    fi
    tail -f "$LOG" | highlight fatal '31;7' err 31 warn 35 notice 36
}

sshscr() {
   # launch a sreen-session over SSH
   ssh $* -t screen -R -D -T xterm-color -e '^Yy'
}

reldate() {
    php -r 'date_default_timezone_set("Europe/Berlin"); print date(DATE_RFC2822,strtotime("'"$*"'")).PHP_EOL;'
}

csscolor_fn() {
    echo 'csscolor() {'
    echo '    COLOR_NAME="$(echo "$1" | tr [A-Z] [a-z])"'
    echo '    case "$COLOR_NAME" in'
    php -r 'preg_match_all("/#([A-F0-9]{6})'"'"'><b> (\w+)<\/b>/",file_get_contents("http://www.w3schools.com/tags/ref_color_tryit.asp"),$m); print json_encode(array_combine($m[2],$m[1]), JSON_PRETTY_PRINT);' \
     | jq -r 'to_entries| .[] | ("        " + .key + ") echo -n " + .value + "; ;;")' \
     | tr [A-Z] [a-z]
    echo '        *) return 1; ;;'
    echo '    esac'
    echo '}'
}

csscolor() {
    COLOR_NAME="$(echo "$1" | tr [A-Z] [a-z])"
    case "$COLOR_NAME" in
        aliceblue) echo -n f0f8ff; ;;
        antiquewhite) echo -n faebd7; ;;
        aqua) echo -n 00ffff; ;;
        aquamarine) echo -n 7fffd4; ;;
        azure) echo -n f0ffff; ;;
        beige) echo -n f5f5dc; ;;
        bisque) echo -n ffe4c4; ;;
        black) echo -n 000000; ;;
        blanchedalmond) echo -n ffebcd; ;;
        blue) echo -n 0000ff; ;;
        blueviolet) echo -n 8a2be2; ;;
        brown) echo -n a52a2a; ;;
        burlywood) echo -n deb887; ;;
        cadetblue) echo -n 5f9ea0; ;;
        chartreuse) echo -n 7fff00; ;;
        chocolate) echo -n d2691e; ;;
        coral) echo -n ff7f50; ;;
        cornflowerblue) echo -n 6495ed; ;;
        cornsilk) echo -n fff8dc; ;;
        crimson) echo -n dc143c; ;;
        cyan) echo -n 00ffff; ;;
        darkblue) echo -n 00008b; ;;
        darkcyan) echo -n 008b8b; ;;
        darkgoldenrod) echo -n b8860b; ;;
        darkgray) echo -n a9a9a9; ;;
        darkgreen) echo -n 006400; ;;
        darkkhaki) echo -n bdb76b; ;;
        darkmagenta) echo -n 8b008b; ;;
        darkolivegreen) echo -n 556b2f; ;;
        darkorange) echo -n ff8c00; ;;
        darkorchid) echo -n 9932cc; ;;
        darkred) echo -n 8b0000; ;;
        darksalmon) echo -n e9967a; ;;
        darkseagreen) echo -n 8fbc8f; ;;
        darkslateblue) echo -n 483d8b; ;;
        darkslategray) echo -n 2f4f4f; ;;
        darkturquoise) echo -n 00ced1; ;;
        darkviolet) echo -n 9400d3; ;;
        deeppink) echo -n ff1493; ;;
        deepskyblue) echo -n 00bfff; ;;
        dimgray) echo -n 696969; ;;
        dodgerblue) echo -n 1e90ff; ;;
        firebrick) echo -n b22222; ;;
        floralwhite) echo -n fffaf0; ;;
        forestgreen) echo -n 228b22; ;;
        fuchsia) echo -n ff00ff; ;;
        gainsboro) echo -n dcdcdc; ;;
        ghostwhite) echo -n f8f8ff; ;;
        gold) echo -n ffd700; ;;
        goldenrod) echo -n daa520; ;;
        gray) echo -n 808080; ;;
        green) echo -n 008000; ;;
        greenyellow) echo -n adff2f; ;;
        honeydew) echo -n f0fff0; ;;
        hotpink) echo -n ff69b4; ;;
        ivory) echo -n fffff0; ;;
        khaki) echo -n f0e68c; ;;
        lavender) echo -n e6e6fa; ;;
        lavenderblush) echo -n fff0f5; ;;
        lawngreen) echo -n 7cfc00; ;;
        lemonchiffon) echo -n fffacd; ;;
        lightblue) echo -n add8e6; ;;
        lightcoral) echo -n f08080; ;;
        lightcyan) echo -n e0ffff; ;;
        lightgoldenrodyellow) echo -n fafad2; ;;
        lightgray) echo -n d3d3d3; ;;
        lightgreen) echo -n 90ee90; ;;
        lightpink) echo -n ffb6c1; ;;
        lightsalmon) echo -n ffa07a; ;;
        lightseagreen) echo -n 20b2aa; ;;
        lightskyblue) echo -n 87cefa; ;;
        lightslategray) echo -n 778899; ;;
        lightsteelblue) echo -n b0c4de; ;;
        lightyellow) echo -n ffffe0; ;;
        lime) echo -n 00ff00; ;;
        limegreen) echo -n 32cd32; ;;
        linen) echo -n faf0e6; ;;
        magenta) echo -n ff00ff; ;;
        maroon) echo -n 800000; ;;
        mediumaquamarine) echo -n 66cdaa; ;;
        mediumblue) echo -n 0000cd; ;;
        mediumorchid) echo -n ba55d3; ;;
        mediumpurple) echo -n 9370db; ;;
        mediumseagreen) echo -n 3cb371; ;;
        mediumslateblue) echo -n 7b68ee; ;;
        mediumspringgreen) echo -n 00fa9a; ;;
        mediumturquoise) echo -n 48d1cc; ;;
        mediumvioletred) echo -n c71585; ;;
        midnightblue) echo -n 191970; ;;
        mintcream) echo -n f5fffa; ;;
        mistyrose) echo -n ffe4e1; ;;
        moccasin) echo -n ffe4b5; ;;
        navajowhite) echo -n ffdead; ;;
        navy) echo -n 000080; ;;
        oldlace) echo -n fdf5e6; ;;
        olive) echo -n 808000; ;;
        olivedrab) echo -n 6b8e23; ;;
        orange) echo -n ffa500; ;;
        orangered) echo -n ff4500; ;;
        orchid) echo -n da70d6; ;;
        palegoldenrod) echo -n eee8aa; ;;
        palegreen) echo -n 98fb98; ;;
        paleturquoise) echo -n afeeee; ;;
        palevioletred) echo -n db7093; ;;
        papayawhip) echo -n ffefd5; ;;
        peachpuff) echo -n ffdab9; ;;
        peru) echo -n cd853f; ;;
        pink) echo -n ffc0cb; ;;
        plum) echo -n dda0dd; ;;
        powderblue) echo -n b0e0e6; ;;
        purple) echo -n 800080; ;;
        red) echo -n ff0000; ;;
        rosybrown) echo -n bc8f8f; ;;
        royalblue) echo -n 4169e1; ;;
        saddlebrown) echo -n 8b4513; ;;
        salmon) echo -n fa8072; ;;
        sandybrown) echo -n f4a460; ;;
        seagreen) echo -n 2e8b57; ;;
        seashell) echo -n fff5ee; ;;
        sienna) echo -n a0522d; ;;
        silver) echo -n c0c0c0; ;;
        skyblue) echo -n 87ceeb; ;;
        slateblue) echo -n 6a5acd; ;;
        slategray) echo -n 708090; ;;
        snow) echo -n fffafa; ;;
        springgreen) echo -n 00ff7f; ;;
        steelblue) echo -n 4682b4; ;;
        tan) echo -n d2b48c; ;;
        teal) echo -n 008080; ;;
        thistle) echo -n d8bfd8; ;;
        tomato) echo -n ff6347; ;;
        turquoise) echo -n 40e0d0; ;;
        violet) echo -n ee82ee; ;;
        wheat) echo -n f5deb3; ;;
        white) echo -n ffffff; ;;
        whitesmoke) echo -n f5f5f5; ;;
        yellow) echo -n ffff00; ;;
        yellowgreen) echo -n 9acd32; ;;
        *)  return 1; ;;
    esac
}


#
# Mac OS X specific
# -----------------------------------------------------------------------------

if [[ $(uname -s) == "Darwin" ]]; then

iterm-bgcolor() {
    case "$1" in -h|-help|--help) echo "Usage: iterm-bgcolor [colorname|hex]"; return 0;; esac
    echo -e "\033]Ph$(csscolor "$1" || echo -n "${1:-000000}")\033\\"
}

iterm-succfail() {
    CODE=$?
    case "$1" in -h|-help|--help) echo "Usage: true;  iterm-succfail"; echo "   or: false; iterm-succfail"; return 0;; esac
    [[ $CODE -eq 0 ]] && iterm-bgcolor 001a00 || iterm-bgcolor 220000
    return $CODE
}

guess-build-cmd() {
    if [ -e ./Makefile ]; then
        echo make "$@";
    elif [ -e ./build.sh ]; then
        echo ./build.sh "$@";
    elif [ -e ./pom.xml ]; then
        echo mvn "$@";
    elif [ -e ./Rakefile ]; then
        echo rake "$@";
    else
        echo make "$@";
    fi
}

makemake() {
    CMD=$(guess-build-cmd "$@")
    callonchange ./ "clear; date; echo; $CMD; iterm-succfail; sleep 1s"
}

manpdf() {
    case "$1" in -h|-help|--help|'') echo "Usage: manpdf [section] name"; return 0;; esac
    man -t "$@" | open -f -a Preview
}

tab() {
    # open a new tab on Terminal with the current working dir
    osascript -e "
        tell application \"System Events\" to tell process \"Terminal\" to keystroke \"t\" using command down
        tell application \"Terminal\" to do script \"cd $PWD \" in selected tab of the front window
    " > /dev/null 2>&1
}

win() {
    # open a new Terminal Window with the current working dir
    osascript -e "
        tell application \"System Events\" to tell process \"Terminal\" to keystroke \"n\" using command down
        tell application \"Terminal\" to do script \"cd $PWD \" in selected tab of the front window
    " > /dev/null 2>&1
}

chrome-reload() {
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

chrome-shift-reload() {
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

last-active-app() {
    # returns to last active application, e.g. use: chrome-reload && last-active-app
    osascript -e "tell application \"System Events\" to keystroke tab using command down" > /dev/null 2>&1
}

cmd-c() {
    # copy to clipboard
    osascript -e "tell application \"System Events\" to keystroke \"c\" using command down" > /dev/null 2>&1
}

cmd-v() {
    # paste from clipboard
    osascript -e "tell application \"System Events\" to keystroke \"v\" using command down" > /dev/null 2>&1
}

esc-and-type-text() {
    TEXT="$(cat)"
    osascript -s ho 2>&1 <<-APPLESCRIPT
tell app "System Events"
    key code 53
    delay 0.3
    keystroke "${TEXT}"
end tell
APPLESCRIPT
}

get-password() {
    security 2>&1 >/dev/null find-generic-password -gs "$@" \
     | awk '/password/{printf "%s", substr($0,12,length($0)-12)}'
}

paste-password() {
    get-password "$@" | esc-and-type-text
}

gifify() {
  case "$1" in
    -h|-help|--help|'')
        echo "Usage: gifify <input_movie.mov> [640x480] [--good]"
        echo "       You DO need to include extension."
        echo "       Note that --good will propably take a looonnnng time..."
        return 0;
        ;;
  esac
  FILE="$1"
  DIM="${2:-640x480}"
  GOOD="$3"
  if [[ -n "$FILE" ]]; then
    DIM="${2:-640x480}"
    if [[ "$GOOD" == '--good' ]]; then
      ffmpeg -i $FILE -r 10 -vcodec png out-static-%05d.png
      time convert -verbose +dither -layers Optimize -resize $DIM\> out-static*.png  GIF:- \
       | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $FILE.gif
      rm out-static*.png
    else
      ffmpeg -i $FILE -s $DIM -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $FILE.gif
    fi
  fi
}

fi # if Darwin



#
# AWS specific
# -----------------------------------------------------------------------------

ec2-hosts() {
    aws ec2 describe-instances "$@" \
      --filters Name=instance-state-name,Values=pending,running,shutting-down,stopping,stopped \
      --output json \
     | jq -r '.Reservations[].Instances[] | [
        .PublicIpAddress,
        .PublicDnsName,
        "#",
        .InstanceId,
        .Placement.AvailabilityZone,
        .State.Name,
        ([(.Tags//[])[]|select(.Key == "Name")|.Value][0]),
        .KeyName
      ] | join("\t")' \
     | column -ts$'\t' \
     | cut -c -$COLUMNS
}


#
# Java specific
# -----------------------------------------------------------------------------

mvn() {
    local PURPLE=$(echo -en "\033[35m")
    local GREEN=$(echo -en "\033[32m")
    local RED=$(echo -en "\033[31m")
    local YELLOW=$(echo -e "\033[33m")
    local BLUE=$(echo -e "\033[1;34m")
    local NORMAL=$(echo -e "\033[0m")

    $(which mvn) "$@" | sed \
        -e "s/^\(.ERROR. .*\)$/$RED\1$NORMAL/                  ; #contain ERROR start 2nd char
        s/^\(Tests run: .*<<< FAILURE\!\)/$RED\1$NORMAL/       ; # contain Tests run: <something> <<< FAILURE
        s/^\( \w*\\([\w\.]*\\).*: .*\)/$RED\1$NORMAL/          ; # a name of method(name of class with package): error message
        s/^\(Failed tests:.*\)/$RED\1$NORMAL/                  ; # contain Failed tests: 
        s/^\(|.*\)/$RED\1$NORMAL/                              ; # line start with pipe
        s/^\(### Content of table.*\)/$RED\1$NORMAL/           ; # line start ### Content of table (dbunit)
        s/^\(Caused by*.*\)/$RED\1$NORMAL/                     ; # line start Caused by
        s/^\(\tat .*\)/$RED\1$NORMAL/                          ; # line start at ... (stack trace)
        s/^\(\t*.*more.*\)/$RED\1$NORMAL/                      ; # line start with tab and contain something with more (stack trace)
        s/^\(##*.*\)/$RED\1$NORMAL/                            ; # line start more than 1 #
        s/^\(Running.*\)/$BLUE\1$NORMAL/                       ; # Line start with Running (surefire)
        s/^\(Tests run: .*[^FAILURE].*\)/${YELLOW}\1${NORMAL}/ ;  # test not failed
        s/^\(.INFO. BUILD FAILURE.*\)$/$RED\1$NORMAL/          ; # BUILD FAILURE
        s/^\(.INFO. ----.*\)$/$PURPLE\1$NORMAL/                ; # INFO of module block
        s/^\(.INFO. Building.*SNAPSHOT\)$/$PURPLE\1$NORMAL/    ; # INFO of module block (with version)
        s/^\(.INFO. --- .* ---.*\)$/$PURPLE\1$NORMAL/          ; # info of plugin
        s/^\(.INFO. .*\)$/$GREEN\1$NORMAL/                     ; # other info
        s/^\(.WARNING. .*\)$/$BLUE\1$NORMAL/                   ; # warning
        s/^\(\w*\.\w*\) \(r [0-9]* w 0 e 0 .* seconds.*\)$/$BLUE\1$NORMAL $YELLOW\2$NORMAL/; 
        s/^\(\w*\.\w*\) \(r [0-9]* w [1-9] e 0 .* seconds.*\)$/$RED\1 \2$NORMAL/; 
        s/^\(\w*\.\w*\) \(r [0-9]* w [1-9] e [1-9] .* seconds.*\)$/$RED\1 \2$NORMAL/; 
        s/^\(\w*\.\w*\) \(r [0-9]* w 0 e [1-9] .* seconds.*\)$/$RED\1 \2$NORMAL/; 
                            # Fitnesse execute test;
        s/^\([^\[].*\)/${YELLOW}\1${NORMAL}/                   ; # line doesn't start with [ 
        " 
}



github-url() {
    (git config --get "remote.$USER.url" || git config --get "remote.origin.url") \
     | jq -R '
        capture("git@(?<host>[^:/]+):(?<org>[^/]+)/(?<repo>[^/]+?).git")
      | "https://\(.host)/\(.org)/\(.repo)"
     ' -r
}

github-web() {
    GITHUB_URL="$( github-url )"
    if [[ -n "$GITHUB_URL" ]]; then
        open "$GITHUB_URL"
    else
        echo >&2 "Error: Could not generate GitHub URL"
    fi
}

