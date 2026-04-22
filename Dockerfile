# --- Phase 1: Build ---
FROM crystallang/crystal:latest-alpine AS builder

# Install build dependencies for Kemal and OpenSSL
RUN apk add --no-cache openssl-dev zlib-dev libevent-dev

WORKDIR /app

# Copy shard.yml first to leverage Docker layer caching
COPY shard.yml ./

# Install dependencies (shards)
# This installs Kemal and any other libraries in your shard.yml
RUN shards install 

# Copy the rest of the source code
COPY . .

# Build the app
# --release: optimizes the binary for speed
# --static: ensures it runs on the tiny alpine image without needing libraries
RUN crystal build src/server.cr --release --static --no-debug -o bin/server

# --- Phase 2: Execution ---
FROM alpine:latest

# Install runtime dependencies
RUN apk add --no-cache openssl libevent

WORKDIR /app

# Copy only the compiled binary from the builder stage
COPY --from=builder /app/bin/server .

# Render uses the PORT environment variable. 
# Kemal looks for this variable by default.
EXPOSE 3000

# Run the binary
CMD ["./server"]
