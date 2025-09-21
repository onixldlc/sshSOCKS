FROM onixldlc/microsocks:latest

RUN apk update && apk upgrade --update --no-cache

RUN apk add --no-cache \
    bash \
    openssh \
    iproute2-tc \
    proxychains-ng \
    iperf3

RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
    base64

WORKDIR /openvpn
COPY . .
RUN chmod u+x ./*.sh

ENTRYPOINT ["bash"]
CMD ["./entrypoint.sh"]