PROJECT_NAME = indeux
RELEASE_VERSION = 2.0.3
GIT_REMOTE_ADDRESS = git@github.com:scetayh/indeux

.PHONY: clean install uninstall pull make-install commit release commit-release strap

${PROJECT_NAME}:
	mkdir -p bin
	cd src && \
		ssc ${PROJECT_NAME}.s.sh ../bin/${PROJECT_NAME}

clean:
	rm -rf bin/*
	rm -rf obj/*
	rm -rf build/*

install:
	mkdir -p /usr/local/bin
	cd bin && \
		cp * /usr/local/bin
	mkdir -p /etc
	cd etc && \
		cp indeux.conf /etc
	cd /etc && \
		chmod 444 indeux.conf; \
		chown root indeux.conf

uninstall:
	cd /usr/local/bin && \
		rm -f ${PROJECT_NAME}
	cd /etc && \
		rm -f indeux.conf

pull:
	git config pull.rebase false
	-git branch --set-upstream-to=origin/main main
	git pull

make-install:
	sudo make uninstall
	make clean
	make
	sudo make install

commit:
	git add .
	-git commit -a

release:
	git remote remove origin
	git remote add origin ${GIT_REMOTE_ADDRESS}
	@printf \\n
	@printf "  Releasing \e[093m${PROJECT_NAME}\e[0m."\\n
	@printf "    \e[092mProject name\e[0m: \e[093m${PROJECT_NAME}\e[0m"\\n
	@printf "    \e[092mRelease version (tag)\e[0m: \e[093m${RELEASE_VERSION}\e[0m"\\n
	@printf "    \e[092mGit remote address\e[0m: \e[093m${GIT_REMOTE_ADDRESS}\e[0m"\\n
	@printf "  Press \e[091many key\e[0m to continue or \e[091mCTRL-C\e[0m to pause."
	@read -s -n1
	@printf \\n
	git tag v${RELEASE_VERSION}
	git push --set-upstream origin main --tags

commit-release:
	make commit
	make release

strap:
	make pull
	make make-install
	make commit-release