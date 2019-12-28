# bootstrap-devmachine
Provision and configure development environment on AWS EC2 instance

1. Deploy the Devmachine
`terraform apply`
2. When finished you will see ip address of the Devmachine
`ip_address = 54.174.190.232`
3. Connect to it using your key: `ssh -i ~/shuraosipov-dev-machine.pem ec2-user@54.174.190.232`
4. Go to an app folder: `cd myapp`
5. `source .env/bin/activate`
6. `pip install -r requirements.txt`
7. Check that all requirements are met and cdk works fine: `cdk ls`
8. Deploy the app: `cdk deploy`
