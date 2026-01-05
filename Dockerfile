FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY Server/MuchToDo/go.mod Server/MuchToDo/go.sum ./

RUN go mod download

COPY Server/MuchToDo/ .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o api ./cmd/api

FROM alpine:latest

WORKDIR /root/

RUN apk --no-cache add ca-certificates

COPY --from=builder /app/api .

COPY Server/MuchToDo/.env ./ 

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["./api"]