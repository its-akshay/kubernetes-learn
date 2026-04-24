# Stage 1: Build
FROM golang:1.23-alpine AS builder
WORKDIR /app

# Copy dependency files first (for caching)
COPY go.mod ./
RUN go mod download

# Copy source code
COPY . .

# Build static binary
RUN CGO_ENABLED=0 GOOS=linux go build -o server .

# Stage 2: Minimal runtime
FROM scratch
COPY --from=builder /app/server /server

EXPOSE 8080
ENTRYPOINT ["/server"]