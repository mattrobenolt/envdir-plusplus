FROM nginx:1.17

COPY bin/envdir++-linux-amd64 /bin/envdir++
COPY test.sh /
COPY .env/ /.env

WORKDIR /

ENTRYPOINT ["/test.sh"]
CMD ["nginx", "-g", "daemon off;"]
