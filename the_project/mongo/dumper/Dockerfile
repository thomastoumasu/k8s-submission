FROM mongo
WORKDIR /usr/src/app
COPY --chmod=755 dumper.sh ./
ENTRYPOINT ["./dumper.sh"]
CMD ["mongodb://the_username:the_password@mongo-svc.project:27017/the_database"]