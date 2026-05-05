# Frontend build stage
FROM node:18 AS frontend-builder

WORKDIR /app

# Clone the repository with HTTPS forced for all git operations
RUN git -c url."https://github.com/".insteadOf="git@github.com:" clone https://github.com/BetterAndBetterII/excalidraw-full.git . && \
    git -c url."https://github.com/".insteadOf="git@github.com:" submodule update --init --recursive

# Build the frontend
RUN cd excalidraw && \
    npm install -g pnpm && \
    pnpm install && \
    cd excalidraw-app && \
    DISABLE_VITE_CHECKER=true pnpm build:app:docker

# Go backend build stage
FROM golang:1.23-alpine AS backend-builder

RUN apk add --no-cache git bash ca-certificates

WORKDIR /app

# Clone the repository with HTTPS forced for all git operations
RUN git -c url."https://github.com/".insteadOf="git@github.com:" clone https://github.com/BetterAndBetterII/excalidraw-full.git . && \
    git -c url."https://github.com/".insteadOf="git@github.com:" submodule update --init --recursive

# Download Go modules
RUN go mod download

# Copy the built frontend from the frontend-builder stage
COPY --from=frontend-builder /app/excalidraw/excalidraw-app/build ./frontend/

# Build the Go application
RUN go build -o excalidraw-server .

# Runtime stage
FROM alpine:latest

RUN apk add --no-cache ca-certificates curl

COPY --from=backend-builder /app/excalidraw-server /app/excalidraw-server
COPY --from=backend-builder /app/frontend /app/frontend
COPY --from=backend-builder /app/config /app/config

RUN mkdir -p /config/data && chmod 755 /config/data

WORKDIR /app

EXPOSE 3002

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:3002 || exit 1

CMD ["./excalidraw-server"]
