# Use the official Node.js image as the base image
FROM node:alpine AS base

# Set the working directory
WORKDIR /app

# Copy the package.json and yarn.lock files
COPY package.json ./

# Install dependencies
RUN npm install --force

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

# Use a smaller base image for the runtime
FROM node:alpine AS runtime

# Set the working directory
WORKDIR /app

# Copy the build output and dependencies from the build stage
COPY --from=base /app/public ./public
COPY --from=base /app/.next ./.next
COPY --from=base /app/node_modules ./node_modules
COPY --from=base /app/package.json ./package.json

# Expose the port the app runs on
EXPOSE 3000

# Start the Next.js application
CMD ["npm", "start"]
