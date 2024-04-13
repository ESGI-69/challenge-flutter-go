FROM golang:latest as builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o /bin/go-app

FROM alpine:latest

COPY --from=builder /bin/go-app /bin/go-app

CMD ["/bin/go-app"]