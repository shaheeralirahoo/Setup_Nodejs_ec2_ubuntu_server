#!/bin/bash

# Update and upgrade the system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Git
echo "Installing Git..."
sudo apt install git -y
git --version

# Install Node.js
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y
node -v
npm -v

# Install PM2 (optional for Node.js process management)
echo "Installing PM2..."
sudo npm install -g pm2
pm2 -v

# Install Nginx
echo "Installing Nginx..."
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
nginx -v

# install certbot
echo "Installing certbot..."
sudo apt install certbot python3-certbot-nginx -y
echo "Certbot Installed..."

# Configure Nginx for Node.js
echo "Configuring Nginx for Node.js..."
NGINX_CONFIG="/etc/nginx/sites-available/default"
sudo bash -c "cat > $NGINX_CONFIG" << 'EOF'
server {
    listen 80;

    server_name _;

    location / {
        proxy_pass http://localhost:3000; # Replace 3000 with your Node.js app's port
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# Test and reload Nginx
sudo nginx -t
sudo systemctl reload nginx

# Final message
echo "Installation and configuration complete!"
echo "Git, Node.js, Nginx,certbot and PM2 are now set up on your system."
