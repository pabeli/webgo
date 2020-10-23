FROM golang:1.12-alpine3.10
WORKDIR /go/src/webCOPY . .
RUN CGO_ENABLED=0 go get -v ./...
FROM scratchCOPY --from=0 /go/bin/web /
ENTRYPOINT ["/web"]