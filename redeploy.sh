#!/bin/bash

# Navigate to the CarVeeps-Backend directory
cd Wing-backend || { echo "Directory Wing not found"; exit 1; }

git reset --hard
# Pull the latest changes from the git repository
git pull || { echo "Git pull failed"; exit 1; }

#Installing the dependencies
npm i

# Restart all PM2 processes
sudo pm2 restart all || { echo "PM2 restart failed"; exit 1; }

# Navigate back to the previous directory
cd - || { echo "Failed to return to the previous directory"; exit 1; }

sudo pm2 log
