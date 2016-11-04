
muhqu's .dotfiles
=================


 * git/svn aware prompt, e.g. showing checkout branch
 * osx specific bash functions to:
    * `win` and `tab` to launch new terminal in current PWD
    * `chrome-reload` and `chrome-shift-reload` to trigger Google Chrome 
    * `last-active-app` to switch to last active app ;)
 * `bin/version` to bump version tags in a git repository
 * `bin/wifi` to turn wifi on/off or show small apple script dialog
 * bunch of special git aliases (or commands):
    * `git ffwd` to update all tracking branches, [more info][git-ffwd] 
    * `git unstash` to pop changes from stash to a dirty working copy, [more info][git-unstash]
    * `git perm-reset` to recover file permissions on uncomitted changed files, [more info][git-perm-reset]
    * `git stash-list` to add check marks to stashes indicating whether they are already applied or not [more info][git-stash-list]
    * `git fetch-pr NUMBER [REMOTE]` to fetch a github pull-request
 * bash function `superspark` to draw nice bar charts on the terminal
 * [iTerm][] specific stuff that most likely requires the [nightly build][iTerm-nightly]
    * `bin/imgcat` to display [images inline][iTerm-images] in the terminal
    * `bin/dotpng` to render [Graphviz][] directly [inline][iTerm-images] in the terminal
    * `iterm-bgcolor` to change the background color of current session
    * `iterm-succfail` to green/red background color wether the last command was successful or not


------

© 2014 by [Mathias Leppich][github] 

[iTerm]: http://www.iterm2.com/
[iTerm-nightly]: http://www.iterm2.com/#/section/downloads
[iTerm-images]: http://www.iterm2.com/images.html
[Graphviz]: http://www.graphviz.org/
[github]: https://github.com/muhqu
[avatar]: http://www.gravatar.com/avatar/8086489bb41f38d0468310ec3ebe68d7?size=32
[git-ffwd]: http://stackoverflow.com/questions/9076361
[git-unstash]: http://stackoverflow.com/questions/3733698
[git-perm-reset]: http://stackoverflow.com/questions/4408378
[git-stash-list]: http://stackoverflow.com/questions/8243321