# ENVDIR++(1)

a good mashup of envdir + docker's env-file. Intended to be used as a docker entrypoint script like:

```
#!/usr/bin/envdir++ /bin/sh
```

This allows pointing `envdir++` to a directory if docker compatible env-file's. See the example `.env/` folder in this repository and `test.sh` scripts for examples of how this works.

Intended use case is pairing Vault Agent with Kubernetes, were Vault Agent runs as an initContainer, spits out secrets as files into `/vault/secrets/*`. This then reads those files and elevates them into environment variables so your application can access them.

Add to your `Dockerfile`:

```Dockerfile
FROM alpine

ENV ENVDIR_VERSION v0.2.0
RUN set -eux; \
    \
    apk add --no-cache --virtual .build-deps \
        gnupg \
        wget \
    ; \
    wget -O /usr/bin/envdir++ "https://github.com/mattrobenolt/envdir-plusplus/releases/download/$ENVDIR_VERSION/envdir++-linux-amd64"; \
    wget -O /usr/bin/envdir++.asc "https://github.com/mattrobenolt/envdir-plusplus/releases/download/$ENVDIR_VERSION/envdir++-linux-amd64.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys D8749766A66DD714236A932C3B2D400CE5BBCA60; \
    gpg --batch --verify /usr/bin/envdir++.asc /usr/bin/envdir++; \
    rm -rf "$GNUPGHOME" /usr/bin/envdir++.asc; \
    chmod +x /usr/bin/envdir++; \
    envdir++ /bin/sh -c 'echo ok'; \
    apk del --no-network .build-deps
```
