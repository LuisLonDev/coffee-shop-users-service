# Use official Node.js image as base
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application source code
COPY . .

# Build the NestJS application
RUN npm run build

# Use a smaller image for the runtime
FROM node:18-alpine AS runner

# Set working directory
WORKDIR /app

# Copy built application from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

# Set environment variables
ENV NODE_ENV=production

# Expose the port (adjust if needed)
EXPOSE 3000

# Start the application
CMD ["node", "dist/main"]
