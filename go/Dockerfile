# GO Repo base repo
FROM golang:alpine3.9 as builder

RUN apk update && apk add --no-cache git

RUN mkdir /app
WORKDIR /app

COPY go.mod ./
COPY go.sum ./

# Download all the dependencies
RUN go mod download

COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# GO Repo base repo
FROM alpine:latest

RUN apk --no-cache add ca-certificates curl

RUN mkdir /app

WORKDIR /app/

FROM scratch

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/main .

# Expose port 8000
EXPOSE 8000

# Run Executable
ENTRYPOINT [ "./main" ]