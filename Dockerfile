FROM golang:1.18-alpine as builder

RUN apk --update --no-cache add make git g++ linux-headers

ARG TAG=v0.40.4

#RUN git clone --branch ${TAG} --single-branch https://github.com/dolthub/dolt.git /go/src/github.com/dolthub/dolt
RUN git clone --branch v0.40.4 --single-branch https://github.com/dolthub/dolt.git /go/src/github.com/dolthub/dolt

WORKDIR /go/src/github.com/dolthub/dolt/go
RUN go build ./cmd/dolt


FROM alpine

RUN addgroup -g 864 -S dolt
RUN adduser -u 864 -SD dolt -G dolt -h /dolt

USER dolt
RUN umask 077
RUN mkdir -p /dolt/data

COPY --from=builder /go/src/github.com/dolthub/dolt/go/dolt /usr/local/bin/dolt
COPY config.yaml /dolt
COPY start.sh /dolt

EXPOSE 3306

ENTRYPOINT ["/dolt/start.sh"]
