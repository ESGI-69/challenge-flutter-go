FROM golang:alpine3.19 as builder

WORKDIR /

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go install github.com/swaggo/swag/cmd/swag@latest

RUN swag init -o ./api/docs

RUN go build -o /main .

FROM alpine:3.13

COPY --from=builder /main /main

CMD ["/main"]
