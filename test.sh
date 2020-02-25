#!bin/envdir++ -f -v -d .env /bin/sh
set -x
env | grep ENVDIR_
exec "$@"
