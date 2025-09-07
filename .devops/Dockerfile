# Stage 1: Build
FROM node:18 AS builder

WORKDIR /app

COPY ../package*.json ./
RUN npm ci

COPY ../ ./
RUN npm run build

# Stage 2: Production
FROM node:18

WORKDIR /app

COPY ../package*.json ./
RUN npm ci --only=production

COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main"]