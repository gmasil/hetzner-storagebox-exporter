FROM alpine

RUN apk add --no-cache nmap-ncat openssl coreutils openssh

ADD check-storage.sh /check-storage.sh
ADD header.sh /header.sh

EXPOSE 80

CMD nc -lk -p 80 -e /header.sh /check-storage.sh
