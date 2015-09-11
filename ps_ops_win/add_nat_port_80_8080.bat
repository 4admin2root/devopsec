netsh interface portproxy add v4tov4 listenport=80 connectaddress=10.2.2.176 connectport=8080
netsh firewall set portopening TCP 80 ENABLE