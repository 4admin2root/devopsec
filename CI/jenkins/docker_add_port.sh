docker inspect -f '{{.NetworkSettings.IPAddress}}' jenkins-server
iptables -A DOCKER ! -i docker0 -o docker0 -p tcp --dport 50000  -d 172.17.0.2 -j ACCEPT
iptables -t nat -A POSTROUTING -p tcp --dport 50000 -s 172.17.0.2 -d 172.17.0.2 -j MASQUERADE
iptables -t nat -A DOCKER ! -i dokcer0 -p tcp --dport 50000 -j DNAT --to-destination 172.17.0.2:50000
