PROJECT_NAME = indeux
RELEASE_VERSION = 2.0.2
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
	printf "Releasing ${PROJECT_NAME}."\\n
	printf "  Project name: ${PROJECT_NAME}"\\n
	printf "  Release version (tag): ${RELEASE_VERSION}"\\n
	printf "  Git remote address: ${GIT_REMOTE_ADDRESS}"\\n
	read -s -n1 -p "Press enter to continue or CTRL-C to pause."
	git tag -a ${RELEASE_VERSION}
	git push --set-upstream origin main --tags

commit-release:
	make commit
	make release

strap:
	make pull
	make make-install
	make commit-release