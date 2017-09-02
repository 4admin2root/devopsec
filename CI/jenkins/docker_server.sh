#!/usr/bin/bash
docker run -d -u root \
--name jenkins
-p 8080:8080 \
-p 50000:50000 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $(which docker):/bin/docker \
-v /var/jenkins_home:/var/jenkins_home \
4admin2root/jenkins:2.60.2
