FROM golang:alpine


ENV GOPATH /opt/gotools

WORKDIR /opt

ADD helloworld.go /opt/helloworld.go



RUN mkdir $GOPATH

CMD ["go", "run", "/opt/helloworld.go"]
