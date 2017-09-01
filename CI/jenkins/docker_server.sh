#!/usr/bin/bash
docker run -d -u root \
-p 8080:8080 \
-p 5000:5000 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /lib64:/lib64 \
-v $(which docker):/bin/docker \
-v /var/jenkins_home:/var/jenkins_home \
jenkins
