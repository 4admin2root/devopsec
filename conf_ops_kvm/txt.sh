virt-install \
--network bridge=virbr0 \
--name centos7_v \
--memory 2048 \
--vcpus 4 \
--location /home/isos/CentOS-7-x86_64-DVD-1503-01.iso \
--disk path=/home/kvm/centos7/centos7_v.img,size=10 \
--graphics none \
--extra-args="console=tty0 console=ttyS0,115200n8"
