# Stage 1: Build
FROM node:18-slim AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY src ./src
COPY tsconfig*.json ./
COPY nest-cli.json ./

RUN npm run build

# Stage 2: Production
FROM node:18-slim

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main"]