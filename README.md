## Setup Nfs Server By Following Command:
    apt install nfs-server
    vi /etc/export
    <Path> <CLIENT-IP>(rw, sync, no_root_squash)
## Use As StorageClass 
    helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
    helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --create-namespace --namespace nfs-provisioner --set nfs.server=<ip> --set nfs.path=/data
## To Have prometheus Operator Follow Step Below:
    cd kube-prometheus-0.13.0
    kubectl create -f kube-prometheus/manifests/setup
    kubectl create -f kube-prometheus/manifests
    kubectl apply -f ../prometheus.yaml

