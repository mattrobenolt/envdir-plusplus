prog=envdir++

bin/$(prog): *.go
	go build -o bin/$(prog) -v -ldflags="-s -w" ./...

all: clean
	docker build --pull --rm -t envdir-plusplus:build .
	docker run --rm -v $(PWD)/bin:/usr/src/$(prog)/bin envdir-plusplus:build
	for f in bin/*; do gpg -ab $$f; done

test-docker:
	docker build --rm -t envdir-plusplus:test -f test.Dockerfile .
	docker run --rm -it envdir-plusplus:test

clean:
	rm -rf bin/

.PHONY: clean
