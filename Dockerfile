# Stage 1: Builder with more space
FROM node:20 as builder

# Install dependencies
RUN apt-get update && apt-get install -y wget git

# Install correct version of Hugo Extended
RUN wget -O /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.134.1/hugo_extended_0.134.1_Linux-ARM64.tar.gz && \
    tar -xzf /tmp/hugo.tar.gz -C /tmp && \
    mv /tmp/hugo /usr/local/bin/ && \
    rm /tmp/hugo.tar.gz

# Install Go (required for Hugo modules)
RUN wget -O /tmp/go.tar.gz https://go.dev/dl/go1.22.0.linux-arm64.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

WORKDIR /app
COPY . .
RUN yarn install --frozen-lockfile

# Stage 2: Final image
FROM node:20-alpine

# Install required dependencies for Hugo
RUN apk add --no-cache git libc6-compat

# Copy Hugo and Go from builder
COPY --from=builder /usr/local/bin/hugo /usr/local/bin/hugo
COPY --from=builder /usr/local/go /usr/local/go
ENV PATH=$PATH:/usr/local/go/bin

COPY --from=builder /app /app
WORKDIR /app

CMD ["yarn", "dev"]