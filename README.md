# Infrastructure Orchestrator Example

## How to Rebuild the Infrastructure from Scratch

1. **Development Environment Setup**
   - Run this project in a DevContainer to simulate a Linux environment with all necessary libraries and isolated credentials

2. **AWS Credentials Configuration**
   - Add your AWS credentials to the `./terraform/aws.env` file
   - A template file `aws.env.example` is provided to show the required format
   - Note: If you're working in a study lab environment, credentials may change after each restart

3. **Infrastructure Initialization**
   - Execute the startup script: `./terraform/scripts/startup-modules-init.sh`

4. **CI/CD Setup**
   - Add the `EC2_SSH_PRIVATE_KEY` and `EC2_IP_ADDRESS` secrets to your repository to enable CI/CD workflows

## Roadmap

- [ ] Implement automatic CI/CD setup with GitHub Actions for the Terraform machine
- [ ] Create a shell script to set GitHub secrets using encrypted security keys
- [ ] Integrate with AWS SSM to create variables during infrastructure creation
- [ ] Add `.env` configuration to specify whether the repository will be managed by a dedicated machine or the user's local machine
- [ ] Configure scripts to consume `.env` variables to define the GitHub repository URL
