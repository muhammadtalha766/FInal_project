# Use Ubuntu as base image
FROM ubuntu:latest

# Install required packages
RUN apt-get update && \
    apt-get install -y git nginx curl gnupg lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js and npm using Nodesource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install MongoDB
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
    gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/8.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-8.0.list && \
    apt-get update && \
    apt-get install -y mongodb-org && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/app

# Clone your repository
RUN git clone https://github.com/muhammadtalha766/Test_mern_app.git .

# Install npm packages
RUN npm install 

# Install npm packages in frontend
WORKDIR /opt/app/frontend
RUN npm install

# Remove the build command if not needed
RUN npm run build

# Continue with the rest of your Dockerfile
WORKDIR /opt/app

# Expose MongoDB and Nginx ports
EXPOSE 27017
EXPOSE 80

# Start MongoDB and Nginx
CMD ["bash", "-c", "mongod --fork --logpath /var/log/mongodb.log &&, npm run server "]

