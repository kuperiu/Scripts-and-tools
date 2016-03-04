#!/bin/bash
rpm -ivh http://pkg.jenkins-ci.org/redhat/jenkins-1.651-1.1.noarch.rpm
/etc/init.d/jenkins start
yum install -y git
mkdir /opt/app && git clone https://github.com/kuperiu/node.git /opt/app
wget https://nodejs.org/dist/v4.3.2/node-v4.3.2-linux-x64.tar.xz -O /opt/nodejs.xz
mkdir /opt/nodejs
name=$(tar tf /opt/nodejs.xz | head -n1)
tar -xf /opt/nodejs.xz
mv /opt/"$name"/* /opt/nodejs/
rm -rf /opt/"$name"
rm -rf /opt/nodejs.xz
echo "export PATH=/opt/nodejs/bin:$PATH" >> /etc/bashrc
#echo "export NODE_PATH='$(npm root -g)'" >> /etc/bashrc
source /etc/bashrc
