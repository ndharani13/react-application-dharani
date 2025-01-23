# Start with a newer Node.js version that is compatible with npm
FROM node:20-alpine as build

WORKDIR /app

# Install the latest npm version
RUN npm install -g npm@latest

# Copy the package.json and package-lock.json files to the container
COPY package.json package-lock.json ./

# Install all dependencies, including devDependencies (no production flag)
RUN npm install --legacy-peer-deps

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Use a smaller image for serving the app (nginx)
FROM nginx:alpine

# Set the working directory to /app (optional, based on your comment to keep it consistent)
WORKDIR /app

# Copy build files from the previous stage to the default nginx HTML directory
COPY --from=build /app/build /usr/share/nginx/html/

# Expose port 80 for serving the app
EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

