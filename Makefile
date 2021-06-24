
.PHONY: build
build: plugins
	:

.PHONY: plugins
plugins:
	cd plugins/source/folder/; sudo docker build . -t pp/source/folder
	cd plugins/process/cat/; sudo docker build . -t pp/process/cat
	cd plugins/process/wc/; sudo docker build . -t pp/process/wc
