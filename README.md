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
## To Enable Metallb And Ingress We Need To install:
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.7/config/manifests/metallb-native.yaml
    kubectl apply -f metallb-ip-pool.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
    
## To Install Argocd:
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    kubectl create namespace argo-rollouts
    kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

    curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-darwin-amd64
    chmod +x ./kubectl-argo-rollouts-darwin-amd64
    sudo mv ./kubectl-argo-rollouts-darwin-amd64 /usr/local/bin/kubectl-argo-rollouts
    kubectl argo rollouts version

