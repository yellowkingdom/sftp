FROM alpine:3.4
MAINTAINER yellowkingdom

RUN echo "http://mirrors.ustc.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories
RUN apk update
RUN apk add --no-cache openssh \
openssh-sftp-server
 
COPY . /app/sshrun/
RUN chmod +x /app/sshrun/run.sh
WORKDIR /app/sshrun/

RUN addgroup ssh
RUN adduser --home /home/ssh ssh -D -s /bin/false -G ssh

EXPOSE 22
ENTRYPOINT ["./run.sh"]