#!/usr/bin/bash
# Install Development toools
#sudo yum -y groupinstall 'Development tools'

# Install and configure docker

sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
## Download miniconda and install python
#
# ++++++++++++++++++++ START ANACONDA INSTALL +++++++++++++++++++++

# Download the Linux Anaconda Distribution
wget https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh -O /tmp/anaconda3.sh

# Run the installer (installing without -p should automatically install into '/' (root dir)
bash /tmp/anaconda3.sh -b -p /home/ec2-user/anaconda3
rm /tmp/anaconda3.sh

### Run the conda init script to setup the shell
echo ". /home/ec2-user/anaconda3/etc/profile.d/conda.sh" >> /home/ec2-user/.bashrc
. /home/ec2-user/anaconda3/etc/profile.d/conda.sh
source /home/ec2-user/.bashrc

# Create a base Python3 environment separate from the base env
conda create -y --name dev python=3.7
conda activate dev
conda install -y -c conda-forge awscli



# Install node and npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install 12
nvm use 12

# Install aws cdk
mkdir myapp && cd myapp
npm install -g aws-cdk
cdk init --language python sample-app
source .env/bin/activate
pip install -r requirements.txt
pip install --upgrade aws-cdk.core

# TODO - isntall jupyterlab notebook
conda install -y -c conda-forge jupyterlab
conda install -y  jupyter
# Run Jupiter Lab by - jupyter lab


#
#
## Install aws cli
#pip install awscli --upgrade --user
#conda activate dev
#conda install -y -c conda-forge awscli
#
## Install node and npm
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
#. ~/.nvm/nvm.sh
#nvm install node npm
## Install aws cdk
#npm install -g aws-cdk
#
##59  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
##   60  . ~/.nvm/nvm.sh
##   61  nvm install node npm
##   62  sudo -E npm install -g aws-cdk
##   63  sudo -e npm install -g aws-cdk
##   64  npm install -g aws-cdk
#
#
#
#
## Donwload and install terraform
##wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
##unzip terraform_0.11.7_linux_amd64.zip
##sudo ln -s ~/terraform /usr/bin/terraform
#
#
#
#
#
#
#
## Install aws sam
##sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
##test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
##test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
##test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
##echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
##brew tap aws/tap
##brew install aws-sam-cli
#
#
#
#
## Install and run Jupiter Server
#
