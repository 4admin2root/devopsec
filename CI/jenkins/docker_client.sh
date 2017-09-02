#!/usr/bin/bash
# create a agent from jenkins server (way: java web start) and then get secret string
#
docker run -d -u root \
--name jenkins-agent \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $(which docker):/bin/docker \
jenkinsci/jnlp-slave \
-url http://10.9.5.75:8080 -workDir=/home/jenkins/agent \
56043611ea14f0eb1d8683af3cab8b83fb5bf9e660a85eb67981488442a0643a test-1
