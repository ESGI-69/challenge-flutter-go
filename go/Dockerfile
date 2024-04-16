FROM golang:alpine3.19 as builder

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -o /app/main .

FROM alpine:3.13

COPY --from=builder /app/main /app/main

CMD ["/app/main"]
