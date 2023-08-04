FROM golang:1.20-alpine AS builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o main

FROM alpine:3.18

RUN apk update && \
    apk --no-cache add bash

COPY --from=builder /app /bin/.

CMD ["/bin/main"]
