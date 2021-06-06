FROM golang:1.16.4-alpine3.13 AS builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o main

FROM alpine:3.13

RUN apk update && \
    apk --no-cache add bash

COPY --from=builder /app /bin/.

RUN ["chmod", "+x", "/bin/entrypoint.sh"]

CMD ["/bin/entrypoint.sh", "db:5432", "-t", "600000000", "--", "/bin/main"]
