# Используем образ Node.js + устанавливаем Hugo
FROM node:20-alpine

# Устанавливаем Hugo (используем версию 0.125.7, как в вашем первом варианте)
RUN wget -O /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v0.125.7/hugo_0.125.7_Linux-ARM64.tar.gz && \
    tar -xzf /tmp/hugo.tar.gz -C /tmp && \
    mv /tmp/hugo /usr/local/bin/ && \
    rm /tmp/hugo.tar.gz

WORKDIR /app

# Копируем зависимости и устанавливаем их
COPY package.json yarn.lock* ./
RUN yarn install --frozen-lockfile

# Копируем весь проект
COPY . .

# Указываем порт
EXPOSE 1313

# Запускаем TinaCMS + Hugo
CMD ["yarn", "dev"]