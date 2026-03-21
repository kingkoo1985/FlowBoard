# Stage 1: Base image
FROM node:20-alpine AS base

# Set working directory
WORKDIR /app

# Copy package files
COPY dashboard/package*.json ./

# Install dependencies
RUN npm ci --only=production

# Stage 2: Build stage
FROM base AS builder

# Copy dashboard files
COPY dashboard/ ./

# Stage 3: Production image
FROM node:20-alpine

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init

WORKDIR /app

# Copy from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app ./dashboard/

# Create non-root user
RUN addgroup -g 1001 -S flowboard && \
    adduser -u 1001 -S flowboard -G flowboard && \
    chown -R flowboard:flowboard /app

# Switch to non-root user
USER flowboard

# Expose port
EXPOSE 18790

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:18790/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start application
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dashboard/server.js"]
