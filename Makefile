
.PHONY: update checkin install

HOME?="~"
WORKINGCOPY=$(shell git status --porcelain | grep -v -e '^??' >/dev/null && echo DIRTY || echo CLEAN)
CHROME_USER_STYLES_DIR=$(HOME)/Library/Application\ Support/Google/Chrome/Default/User\ Stylesheets
CHROME_CUSTOM_CSS_SYMLINK=$(CHROME_USER_STYLES_DIR)/Custom.css

update :
	@test "$(WORKINGCOPY)" == "CLEAN" || (echo "Failed: working copy not clean! commit or stash changes..."; exit 1)

checkin : 
	git add .
	git commit -v

install :
	git ls-files | awk '/^(\.|bin\/)/' | xargs -t -n1 -I% sh -c "rm $(HOME)/% 2>/dev/null; ln -s $(CURDIR)/% $(HOME)/%"
	test -d $(CHROME_USER_STYLES_DIR) || mkdir -p $(CHROME_USER_STYLES_DIR)
	test -L $(CHROME_CUSTOM_CSS_SYMLINK) || ln -s $(HOME)/.custom.css $(CHROME_CUSTOM_CSS_SYMLINK)
