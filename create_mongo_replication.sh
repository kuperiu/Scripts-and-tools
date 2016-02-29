#!/bin/bash
declare -a arr
sudo yum install -y fping.x86_64
install_mongo () {
  #!/bin/bash
  sudo echo "[mongodb-org-3.2]" >> /etc/yum.repos.d/mongodb-org-3.2.repo
  sudo echo "name=MongoDB Repository" >> /etc/yum.repos.d/mongodb-org-3.2.repo
  sudo echo "baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.2/x86_64/" >> /etc/yum.repos.d/mongodb-org-3.2.repo
  sudo echo "gpgcheck=0" >> /etc/yum.repos.d/mongodb-org-3.2.repo
  sudo echo "enabled=1" >> /etc/yum.repos.d/mongodb-org-3.2.repo

  lunch_index=$(curl -s http://169.254.169.254/latest/meta-data/ami-launch-index/)
  sudo yum install -y mongodb-org
  sudo sed -i 's/bindIp/#bindIp/g' /etc/mongod.conf
  sudo echo "replication:" >> /etc/mongod.conf
  sudo echo "  replSetName: rs0" >> /etc/mongod.conf
  sudo /etc/init.d/mongod start

  if [ 0 -eq $lunch_index ]; then
    #activate mongo
    is_on=$(nc -z localhost 27017)
    while [ -z "$is_on" ]; do
     sleep 10
     is_on=$(nc -z localhost 27017)
    done
    sleep 10
    mongo --eval "rs.initiate()"
  fi
}
discover () {
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
  az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
  az=$(echo $az | sed 's/.$//g')
  discover
  lunch_index=$(curl -s http://169.254.169.254/latest/meta-data/ami-launch-index/)
  if [ 0 -eq $lunch_index ]; then
    var=$(echo ${arr[0]} | sed 's/\./-/g')
    var=$(echo "ip-"$var"."$az".compute.internal")
    mongo --eval "rs.add('$var')"
    var=$(echo ${arr[1]} | sed 's/\./-/g')
    var=$(echo "ip-"$var"."$az".compute.internal")
    mongo --eval "rs.add('$var')"
  fi
}
create_repication
