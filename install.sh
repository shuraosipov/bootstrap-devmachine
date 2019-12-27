#!/usr/bin/bash
# Install Development toools
# sudo yum -y groupinstall 'Development tools'
sudo yum -y install wget curl

# Install and configure docker
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

# Download miniconda and install python
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p "$HOME"/miniconda
~/miniconda/bin/conda create -y -n dev python=3.7 anaconda
~/miniconda/bin/conda activate dev

# Install aws cli
pip install awscli --upgrade --user

# Install node and npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install node

# Install aws cdk
sudo npm install -g aws-cdk


# Donwload and install terraform
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip terraform_0.11.7_linux_amd64.zip
sudo ln -s ~/terraform /usr/bin/terraform







# Install aws sam
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
#test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
#test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
#test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
#echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
#brew tap aws/tap
#brew install aws-sam-cli




# Install and run Jupiter Server

