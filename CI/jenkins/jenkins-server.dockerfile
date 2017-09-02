FROM jenkins:2.60.2
USER root
RUN echo "deb http://mirrors.aliyun.com/debian stretch main" > /etc/apt/sources.list \
  && echo "deb http://mirrors.aliyun.com/debian stretch-updates main" >> /etc/apt/sources.list \
  && echo "deb http://mirrors.aliyun.com/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y libltdl7
RUN groupadd docker && gpasswd -a jenkins docker
USER jenkins
