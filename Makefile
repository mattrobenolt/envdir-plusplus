prog=envdir++

bin/$(prog): *.go
	go build -o bin/$(prog) -v -ldflags="-s -w" ./...

all: clean
	docker build --pull --rm -t envdirpp:build .
	docker run --rm -v $(PWD)/bin:/usr/src/$(prog)/bin envdirpp:build
	for f in bin/*; do gpg -ab $$f; done

clean:
	rm -rf bin/

.PHONY: clean
