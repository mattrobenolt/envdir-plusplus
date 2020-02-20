# envdir-++

a good mashup of envdir + docker's env-file. Intended to be used as a docker entrypoint script like:

```
#!/usr/bin/envdir++ /bin/sh
```

This allows pointing `envdir++` to a directory if docker compatible env-file's. See the example `.env/` folder in this repository and `test.sh` scripts for examples of how this works.

Intended use case is pairing Vault Agent with Kubernetes, were Vault Agent runs as an initContainer, spits out secrets as files into `/vault/secrets/*`. This then reads those files and elevates them into environment variables so your application can access them.
