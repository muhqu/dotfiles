
.PHONY: update checkin install

HOME?="~"
WORKINGCOPY=$(shell git status --porcelain | grep -v -e '^??' >/dev/null && echo DIRTY || echo CLEAN)

update :
	@test "$(WORKINGCOPY)" == "CLEAN" || (echo "Failed: working copy not clean! commit or stash changes..."; exit 1)
	git ls-files | awk '!/^Makefile/' | xargs -t -n1 -I% cp $(HOME)/% %

checkin : 
	git add .
	git commit -v

install :
	git ls-files | awk '!/^Makefile/' | xargs -t -n1 -I% cp % $(HOME)/%
	git ls-files | awk '/^bin\//' | xargs -t -n1 -I% chmod +x $(HOME)/%
