# Stage 1: Builder with more space
FROM node:20 as builder

# Install Hugo
RUN wget -O /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.125.7/hugo_0.125.7_Linux-ARM64.tar.gz && \
    tar -xzf /tmp/hugo.tar.gz -C /tmp && \
    mv /tmp/hugo /usr/local/bin/ && \
    rm /tmp/hugo.tar.gz

WORKDIR /app
COPY . .
RUN yarn install --frozen-lockfile

# Stage 2: Final image
FROM node:20-alpine
COPY --from=builder /usr/local/bin/hugo /usr/local/bin/hugo
COPY --from=builder /app /app
WORKDIR /app

EXPOSE 1313
CMD ["yarn", "dev"]