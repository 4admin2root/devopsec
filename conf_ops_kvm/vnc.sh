virt-install \
--network bridge=br0 \
--name centos6 \
--memory 3072 \
--vcpus 2 \
--cdrom /home/kvm/centos6/CentOS-6.7-x86_64-bin-DVD1.iso \
--disk path=/home/kvm/centos6/centos6.img,size=10 \
--graphic vnc,password=foobar,port=5910 \
--os-variant rhel6
#--extra-args="console=tty0 console=ttyS0,115200n8"
