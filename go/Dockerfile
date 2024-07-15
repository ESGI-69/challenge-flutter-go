FROM golang:alpine3.20 as builder

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go install github.com/swaggo/swag/cmd/swag@latest

RUN swag init -o ./api/docs

RUN go build -o /app/main .

FROM alpine:3.20

COPY assets /assets
COPY backoffice /backoffice
COPY --from=builder /app/main /main

CMD ["/main"]
