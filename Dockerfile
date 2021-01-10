#  Build Phase: Base image
FROM node:alpine

# Build Phase: Working directory to resolve node v15 build error
WORKDIR '/app'

# Build Phase: Copy over dependency file to working dir
COPY package.json .

# Build Phase: then install dependencies
RUN npm install

# Build Phase: AFTER installing dependencies THEN get source code
COPY . .

# Build Phase: Provide default command for container startup
RUN npm run build
# This command produces a prod build folder within the WORKDIR of container

# Run Phase: Second base image for production build of web app
FROM nginx

# In order to deploy successfully to AWS there must be an exposed port
EXPOSE 80

# Run Phase: Copy over folder from builder phase with from=0
COPY --from=0 /app/build /usr/share/nginx/html

# Default command of nginx container starts the server automatically