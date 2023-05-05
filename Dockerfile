# Customized Dockerfile for A11y
# Use node:14-alpine as the base image
FROM node:14-alpine

# Set the container working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json

# Install dependencies
RUN npm ci

# Copy the rest of the application code
COPY . .

# Healthcheck dependencies
COPY --from=louislam/uptime-kuma:builder-go /app/extra/healthcheck /app/extra/healthcheck

# Make the entrypoint script executable
RUN chmod +x /app/extra/entrypoint.sh

# Expose port
EXPOSE 3001

# Define volume
VOLUME ["/app/data"]

# Set environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1

# Define healthcheck
HEALTHCHECK --interval=60s --timeout=30s --start-period=180s --retries=5 CMD extra/healthcheck

# Define entrypoint and command
ENTRYPOINT ["/usr/bin/dumb-init", "--", "extra/entrypoint.sh"]
CMD ["node", "server/server.js"]
