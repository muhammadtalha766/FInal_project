# Use Ubuntu as the base image
FROM ubuntu

# Update package list and install dependencies (curl, git, gnupg)
RUN apt-get update && apt-get install -y curl git gnupg

# Install Nginx
RUN apt-get install -y nginx

# Set the working directory
WORKDIR /opt/app

# Copy the entire project into the container
COPY . .

# Install Node.js (v20) directly from NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install MongoDB dependencies and MongoDB
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-8.0.list && \
    apt-get update && \
    apt-get install -y mongodb-org

# Change to frontend directory and install npm packages
WORKDIR /opt/app/frontend
RUN npm install
RUN npm run build

# Start MongoDB and Nginx in the foreground
CMD ["bash", "-c", "mongod --bind_ip 0.0.0.0 --fork --logpath /var/log/mongodb.log --dbpath /data/db && nginx -g 'daemon off;'"]

