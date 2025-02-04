# Redeployment Script Guide

This guide explains how to use the provided Bash script to redeploy an already deployed project by pulling the latest updates from Git, installing dependencies, and restarting the application using PM2.

## Prerequisites
- The project is already deployed on the server.
- Git is installed and configured.
- Node.js and npm are installed.
- PM2 is installed and managing the application.

## Usage Instructions

### Step 1: Upload the Script to Your Server
1. Copy the script (`redeploy.sh`) to your server.
2. Move it to your project directory if needed.
3. Ensure the script has execution permissions:
   ```bash
   chmod +x redeploy.sh
   ```

### Step 2: Run the Script
Execute the script by running:
```bash
./redeploy.sh
```

### What the Script Does
1. **Navigates to the project directory**: Ensures the script is running in the correct folder.
2. **Resets any local changes**: Prevents conflicts with the remote repository.
3. **Pulls the latest changes from Git**: Updates the project to the latest version.
4. **Installs dependencies**: Ensures all required packages are up to date.
5. **Restarts the application using PM2**: Applies the updates without downtime.
6. **Logs PM2 output**: Displays the application's running logs for debugging.

### Troubleshooting
- **Directory Not Found**: Ensure the correct project directory name is set in the script.
- **Git Pull Failed**: Check for authentication issues or repository access problems.
- **PM2 Restart Failed**: Verify PM2 is installed and the application is properly registered.

## Conclusion
This script simplifies redeploying your application, ensuring a smooth and automated update process. Modify it as needed to suit your project’s requirements.

