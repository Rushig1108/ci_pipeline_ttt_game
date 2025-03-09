# Use Node.js for building the application
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first for efficient caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React application using Vite
RUN npm run build

# Serve the built application using Nginx
FROM nginx:stable-alpine

# Copy built files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom Nginx configuration if needed
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose necessary ports
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
