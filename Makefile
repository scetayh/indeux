PROJECT_NAME = indeux
RELEASE_VERSION = 5.0.1
GIT_REMOTE_ADDRESS = git@github.com:scetayh/indeux

.PHONY: clean install uninstall pull strap commit tag remote debug release revoke

${PROJECT_NAME}:
	mkdir -p bin
	cd src && \
		ssc ${PROJECT_NAME}.s.sh ../bin/${PROJECT_NAME}

clean:
	rm -rf bin/*
	rm -rf obj/*
	rm -rf build/*

test:
	sudo indeux -i
	sudo indeux -g
	echo
	@echo "Waiting for 3 seconds..."
	sleep 3
	links index.html
	sudo indeux -r
	sudo indeux -u

install:
	mkdir -p /usr/local/bin
	cd bin && \
		cp * /usr/local/bin
	\
	mkdir -p /usr/local/share/doc/indeux
	cd doc && \
		cp -r * /usr/local/share/doc/indeux
	cd /usr/local/share/doc/indeux && \
		chmod 666 local.conf usage.txt && \
		chown root local.conf usage.txt
	\
	echo "INDEUX_SYSTEM_VERSION=${RELEASE_VERSION}" > /etc/indeux.system.conf
	cd /etc && \
		chmod 444 indeux.system.conf; \
		chown root indeux.system.conf

uninstall:
	-cd /usr/local/bin && \
		rm -f ${PROJECT_NAME}
	-cd /usr/local/share/doc && \
		rm -rf ${PROJECT_NAME}
	-cd /etc && \
		rm -f indeux.system.conf

pull:
	git config pull.rebase false
	-git branch --set-upstream-to=origin/main main
	git pull

strap:
	-make pull
	sudo make uninstall
	make clean
	make
	sudo make install
	make test

commit:
	git add .
	git commit -a

tag:
	@printf \\n
	@printf "  Adding tag for \e[093m${PROJECT_NAME}\e[0m."\\n
	@printf "    \e[092mProject name\e[0m: \e[093m${PROJECT_NAME}\e[0m"\\n
	@printf "    \e[092mTag (Release version)\e[0m: \e[093m${RELEASE_VERSION}\e[0m"\\n
	@printf "  Press \e[091many key\e[0m to continue or \e[091mCTRL-C\e[0m to pause."
	@read -s -n1
	@printf \\n
	@printf \\n
	git tag v${RELEASE_VERSION}

remote:
	git remote remove origin
	git remote add origin ${GIT_REMOTE_ADDRESS}

debug:
	make strap
	make commit
	make remote
	git push --set-upstream origin main

release:
	make strap
	make commit
	make tag
	make remote
	git push --set-upstream --tags origin main

revoke:
	@printf \\n
	@printf "  Removing tag for \e[093m${PROJECT_NAME}\e[0m."\\n
	@printf "    \e[092mProject name\e[0m: \e[093m${PROJECT_NAME}\e[0m"\\n
	@printf "    \e[092mTag (Revoke version, in shell variable version)\e[0m: \e[093m${version}\e[0m"\\n
	@printf "  Press \e[091many key\e[0m to continue or \e[091mCTRL-C\e[0m to pause."
	@read -s -n1
	@printf \\n
	@printf \\n
	git tag -d v${version}
	git push origin :refs/tags/v${version}
