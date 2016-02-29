#!/bin/bash
<<COMMENT
Automatically install mongodb 3.2 and configure 3 nodes replication
Instruction:
1. Pick Amazon Linux AMI as your instance
2. Configure 3 instances for luncg
3. Copy paste this script to the userdata field
4. Make sure that all traffic is allowd in the private subnet of instances
COMMENT
declare -a arr
install_mongo () {
  #!/bin/bash
  sudo echo "[mongodb-org-3.2]" >> /etc/yum.repos.d/mongodb-org-3.2.repo
  sudo echo "name=MongoDB Repository" >> /etc/yum.repos.d/mongodb-org-3.2.repo
  sudo echo "baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.2/x86_64/" >> /etc/yum.repos.d/mongodb-org-3.2.repo
  sudo echo "gpgcheck=0" >> /etc/yum.repos.d/mongodb-org-3.2.repo
  sudo echo "enabled=1" >> /etc/yum.repos.d/mongodb-org-3.2.repo
  sudo yum install -y mongodb-org
  sudo sed -i 's/bindIp/#bindIp/g' /etc/mongod.conf
  sudo echo "replication:" >> /etc/mongod.conf
  sudo echo "  replSetName: rs0" >> /etc/mongod.conf
  sudo /etc/init.d/mongod start
  chkconfig mongod on
}
#Scans the subnet for the 2 secondaries nodes
discover () {
  sudo yum install -y fping.x86_64
  nodes=0
  begin=$(route -n | tail -n1 | awk {'print $1'})
  end=$(ifconfig | head -n2 | tail -n1 | awk {'print $3'} | sed 's/Bcast://g')
  gateway=$(route -n | awk {'print $2'} | tail -n3 | head -n1)
  ip=$(ifconfig | head -n2 | tail -n1 | awk {'print $2'} | sed 's/addr://g')
  while [[ "$begin" != "$end" && $nodes -lt 2 ]]; do
   forth=$(echo "$begin" | sed 's/[0-9]*\.//g')
   third=$(echo "$begin" | sed 's/\.[0-9]*$//g' | sed 's/[0-9]*\.//g')
   second=$(echo "$begin" | sed 's/\.[0-9]*$//g' | sed 's/\.[0-9]*$//g' | sed 's/[0-9]*\.//g')
   first=$(echo "$begin" | sed 's/\.[0-9]*$//g' | sed 's/\.[0-9]*$//g' | sed 's/\.[0-9]*$//g')
   if [[ $forth -eq 255 ]]; then
    forth=0
    third=$(($third+1))
   else
    forth=$(($forth+1))
   fi
   begin=$first"."$second"."$third"."$forth
   fping $begin -t 1 &> /dev/null
   if [ $? -eq 0 ]; then
    if [[ $ip != $begin && $gateway != $begin ]]; then
     arr+=($begin)
     nodes=$(($nodes+1))
    fi
   fi
  done
}
create_repication () {
  install_mongo
  lunch_index=$(curl -s http://169.254.169.254/latest/meta-data/ami-launch-index/)
  if [ 0 -eq $lunch_index ]; then
    az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
    az=$(echo $az | sed 's/.$//g')
    discover
    mongo --eval "rs.initiate()"
    dns=$(echo ${arr[0]} | sed 's/\./-/g')
    dns=$(echo "ip-"$dns"."$az".compute.internal")
    mongo --eval "rs.add('$dns')"
    dns=$(echo ${arr[1]} | sed 's/\./-/g')
    dns=$(echo "ip-"$dns"."$az".compute.internal")
    mongo --eval "rs.add('$dns')"
  fi
}
create_repication
