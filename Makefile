PROJECT_NAME = indeux
PROJECT_VERSION = 0.2.0
PROJECT_TYPE = bin
GITHUB_USERNAME = scetayh
GITHUB_REPOSITORY_NAME = indeux

.PHONY: clean install uninstall pull push deploy

${PROJECT_NAME}:
	if [ ${PROJECT_TYPE} = bin ]; then \
		mkdir -pv bin; \
		cd src && bash ssc ${PROJECT_NAME}-${PROJECT_VERSION}.s.sh ../bin/${PROJECT_NAME}; \
	elif [ ${PROJECT_TYPE} = lib ]; then \
		make install; \
	else \
		exit 1; \
	fi

clean:
	-rm -rfv bin/*
	-rm -rfv obj/*

install:
	if [ ${PROJECT_TYPE} = bin ]; then \
		mkdir -pv /usr/local/bin && cp bin/* /usr/local/bin/; \
		mkdir -pv /usr/local/share/doc/indeux && cp indeux.conf.example /usr/local/share/doc/indeux/; \
	elif [ ${PROJECT_TYPE} = lib ]; then \
		mkdir -pv /usr/local/lib/${PROJECT_NAME} && cp lib/* /usr/local/lib/${PROJECT_NAME}/ && chmod 777 -R /usr/local/lib/${PROJECT_NAME}/*; \
		echo "Operate the command below to add ${PROJECT_NAME} to your paths."; \
		echo; \
		echo "        echo \"/usr/local/lib/${PROJECT_NAME}\" >> /etc/paths"; \
		echo; \
	else \
		exit 1; \
	fi

uninstall:
	rm -rfv /usr/local/${PROJECT_TYPE}/${PROJECT_NAME}

pull:
	git config pull.rebase false
	git pull

push:
	git remote remove origin
	git remote add origin git@github.com:${GITHUB_USERNAME}/${GITHUB_REPOSITORY_NAME}
	git add .
	-git commit -a -m "v${PROJECT_VERSION}"
	git push --set-upstream origin main

deploy:
	make test
	make push

test:
	make clean
	make
	sudo make install
	sudo indeux init
	sudo indeux gen
	sudo indeux remove
	sudo rm -rfv ./.indeux