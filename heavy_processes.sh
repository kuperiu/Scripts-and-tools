!/bin/bash
<<COMMENT
This script checks if the 5 heaviest processes are taking more than 80% of the total server memory
If so it will send a table of the processes names and the memory they consume
COMMENT
#check how much memory the 5 heaviest processes are consuming and the total memory on the server
sum=$(ps -e -o rss,cmd | sort -nk +1 | awk {'print $1,$2'} | tail -n 5 | awk '{ sum+=$1} END {print sum}')
total=$(free -k | sed -n 2p | awk {'print awk $2'})

#if the process are taking 80 percents of the tootal memory
if (($(($total*80/100)) < $sum)); then
 processes=($(ps -e -o rss,cmd | sort -nk +1 | awk {'print $1,$2'} | tail -n 5))
 i=0
 declare -A name
 #render the html
 (
 echo "To: mail@example.com"
 echo "Subject: $(hostname) is overloaded"
 echo "Content-Type: text/html"
 echo
 echo "<html><body><table border=1>"
 echo "<th>Memory</th><th>Process Name</th>"
 for process in ${processes[@]}; do
  if [ $(($i%2)) -eq 0 ]; then
   echo "</tr><td>$process</td>"
  else
   echo "<td>$process</td></tr>"
  fi
 i=$(($i+1))
 done
 echo "</table></body></html>"
 ) | /usr/sbin/sendmail -t
fi
