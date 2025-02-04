# Git, Node.js, Nginx, Certbot, and PM2 Setup Guide

This guide provides step-by-step instructions to set up an EC2 instance, allocate an Elastic IP, install and configure Git, Node.js, PM2, Nginx, and Certbot, and optionally configure an S3 bucket with IAM user permissions. Each step includes explanations to help you understand the process.

## Step 1: Create an EC2 Instance
EC2 (Elastic Compute Cloud) provides scalable cloud computing. Follow these steps to create an instance:

1. Log in to AWS Management Console.
2. Navigate to the **EC2 Dashboard**.
3. Click **Launch Instance**.
4. Choose an Amazon Machine Image (AMI), e.g., **Ubuntu 22.04**.
5. Select an instance type (e.g., **t2.micro** for free tier eligibility).
6. Configure instance details and security group settings (allow SSH, HTTP, and HTTPS traffic).
7. Click **Launch** and select an existing key pair or create a new one.
8. Click **Launch Instances** and wait for the instance to start.

## Step 2: Allocate an Elastic IP
Elastic IP ensures your instance has a static IP, preventing changes on restarts.

1. Navigate to the **EC2 Dashboard**.
2. In the left panel, select **Elastic IPs** under **Network & Security**.
3. Click **Allocate Elastic IP Address**.
4. Choose **Amazon's pool of IPv4 addresses** and click **Allocate**.
5. Select the allocated Elastic IP and click **Associate**.
6. Choose your EC2 instance and click **Associate**.

## Step 3: Update and Upgrade the System
Keeping your system updated improves security and performance.
```bash
sudo apt update && sudo apt upgrade -y
```

## Step 4: Install Git
Git is essential for version control and managing source code.
```bash
sudo apt install git -y
```
Verify installation:
```bash
git --version
```

## Step 5: Install Node.js and npm
Node.js runs JavaScript on the server, and npm is its package manager.
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y
```
Verify installation:
```bash
node -v
npm -v
```

## Step 6: Install PM2 (Process Manager for Node.js)
PM2 keeps your Node.js app running even after a crash or restart.
```bash
sudo npm install -g pm2
```
Verify installation:
```bash
pm2 -v
```

## Step 7: Install and Configure Nginx
Nginx is a web server that can act as a reverse proxy for Node.js.
```bash
sudo apt install nginx -y
```
Start and enable it:
```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```
Verify installation:
```bash
nginx -v
```

## Step 8: Install Certbot for SSL Certificates
Certbot enables HTTPS by providing free SSL certificates.
```bash
sudo apt install certbot python3-certbot-nginx -y
```

## Step 9: Clone Your Git Repository and Start Application with PM2

### 1. Create a Classic GitHub Token
A GitHub token is required for cloning private repositories.

1. Log in to **GitHub**.
2. Navigate to **Settings** > **Developer Settings** > **Personal Access Tokens**.
3. Click **Generate new token (classic)**.
4. Select **repo** scope for private repositories.
5. Generate and copy the token.

### 2. Clone Your Repository
Replace `<TOKEN>` and `<REPO_URL>` with your actual token and repository URL:
```bash
git clone https://<TOKEN>@github.com/<USERNAME>/<REPOSITORY>.git
```

### 3. Start Your Application with PM2
Navigate to the cloned repository and start your Node.js application:
```bash
cd <REPOSITORY>
npm install
npm run build  # If applicable
pm2 start <FILE_NAME>
```
Replace `<FILE_NAME>` with the main file of your application (e.g., `app.js` or `server.js`).

## Step 10: Configure Nginx as a Reverse Proxy for Node.js
Nginx forwards web traffic to your Node.js application.
```bash
NGINX_CONFIG="/etc/nginx/sites-available/default"
sudo bash -c "cat > $NGINX_CONFIG" << 'EOF'
server {
    listen 80;
    server_name _;
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF
```

## Step 11: Test and Reload Nginx
```bash
sudo nginx -t
sudo systemctl reload nginx
```

## Optional: Configure an S3 Bucket with IAM User Permissions
### 1. Create an S3 Bucket
1. Navigate to the **S3 Dashboard** in AWS.
2. Click **Create Bucket**.
3. Provide a unique bucket name.
4. Disable **Block all public access**.
5. Click **Create Bucket**.

### 2. Set Bucket Policy for Public Read Access
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::your-bucket-name/*"
        }
    ]
}
```
Replace `your-bucket-name` with your actual bucket name.

### 3. Create an IAM User with S3 Full Access
1. Go to the **IAM Dashboard**.
2. Click **Users** > **Add User**.
3. Select **Programmatic access**.
4. Attach **AmazonS3FullAccess** policy.
5. Click **Create User** and save the credentials.

## Final Message
Once the script completes, your EC2 instance is set up with Git, Node.js, PM2, Nginx, and Certbot. Additionally, if opted, your S3 bucket is configured for public read access with an IAM user for management.

**You can use the provided Node.js setup shell script to automate this entire process when setting up your server. Simply upload the script to your instance and execute it for a streamlined installation experience.**

### Troubleshooting Tips
- **Port Conflicts:** Ensure no other applications are using ports 80, 443, or 3000.
- **Git Clone Authentication Issues:** Double-check your token and repository URL.
- **Nginx Not Restarting:** Check logs using `sudo journalctl -u nginx --no-pager | tail -n 50`.
- **PM2 Not Persisting:** Run `pm2 startup` to configure auto-start.

By following this guide, you will gain a deeper understanding of cloud infrastructure, server configuration, and deployment best practices. 🚀
