# Infrastructure Orchestrator

## How to build and use the Infrastructure from Scratch

1. **Development Environment Setup**
   - Run this project in a DevContainer to simulate a Linux environment with all necessary libraries and isolated credentials

2. **AWS Credentials Configuration**
   - Add your AWS credentials to the `.aws.env` file
   - A template file `.aws.env.example` in the same directory is provided to show the required format
   - Note: If you're working in a study lab environment, credentials may change after each restart

3. **Infrastructure Initialization**
   - Execute the startup script: `./bootstrap-init.sh`

4. **CI/CD Setup**
   - Add the `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN` secrets to your repository to enable CI/CD workflows

5. **Ready to Go**
   - The infrastructure is now ready for use. Just push something to `./terraform`
