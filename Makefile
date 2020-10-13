VER = 1.0.0
GBOX = granatumx/gbox-deseq2:$(VER)

docker:
	docker build --build-arg VER=$(VER) --build-arg GBOX=$(GBOX) -t $(GBOX) .

docker-push:
	docker push $(GBOX)

shell:
	docker run -it $(GBOX) /bin/bash

doc:
	./gendoc.sh
