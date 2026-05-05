# Build from excalidraw-full repository (Go + Frontend application)
FROM golang:1.23-alpine AS builder

RUN apk add --no-cache git bash ca-certificates

WORKDIR /src

# Clone the repository
RUN git clone https://github.com/BetterAndBetterII/excalidraw-full.git . 

# Build the Go application
RUN go build -o excalidraw-server .

# Runtime stage
FROM alpine:latest

RUN apk add --no-cache ca-certificates curl

COPY --from=builder /src/excalidraw-server /app/excalidraw-server
COPY --from=builder /src/frontend /app/frontend
COPY --from=builder /src/core /app/core
COPY --from=builder /src/config /app/config

RUN mkdir -p /config/data && chmod 755 /config/data

WORKDIR /app

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:3000 || exit 1

CMD ["./excalidraw-server"]
