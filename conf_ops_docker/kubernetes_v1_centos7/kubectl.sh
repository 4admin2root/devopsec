kubectl version --server=http://10.3.1.46:8080

kubectl get nodes --server=http://10.3.1.46:8080

kubectl create -f apache.json --server=http://10.3.1.46:8080

kubectl get pods --server=http://10.3.1.46:8080


etcdctl --peers 10.3.1.46:2379 get /registry/pods/default/apache