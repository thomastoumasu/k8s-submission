FROM alpine/curl
WORKDIR /usr/src/app
COPY --chmod=755 generator.sh ./
ENTRYPOINT ["./generator.sh"]