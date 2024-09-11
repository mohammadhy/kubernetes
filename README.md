## setup insecure registry for containerd
       [plugins."io.containerd.grpc.v1.cri".registry]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."IP:PORT"]
          endpoint = ["http://IP:PORT"]
        [plugins."io.containerd.grpc.v1.cri".registry.configs."IP:PORT".tls]
          insecure_skip_verify = true
        [plugins."io.containerd.grpc.v1.cri".registry.configs."IP:PORT".auth]
           password = "admin"
           username = "admin"
## Setup Nfs Server By Following Command:
    apt install nfs-server
    vi /etc/export
    <Path> <CLIENT-IP>(rw, sync, no_root_squash)
## Use As StorageClass 
    helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
    helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --create-namespace --namespace nfs-provisioner --set nfs.server=<ip> --set nfs.path=/data
## To Have prometheus Operator Follow Step Below:
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    helm install prometheus prometheus-community/kube-prometheus-stack
## To Enable Metallb And Ingress We Need To install:
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.7/config/manifests/metallb-native.yaml
    kubectl apply -f metallb-ip-pool.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
    
## To Install Argocd And Argocd Rollout:
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    kubectl create namespace argo-rollouts
    kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

    curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-amd64
    chmod +x ./kubectl-argo-rollouts-darwin-amd64
    sudo mv ./kubectl-argo-rollouts-darwin-amd64 /usr/local/bin/kubectl-argo 
    kubectl-argo rollouts version --kubeconfig 
## Find PID And DockerID
    with top and htop we can find most pid use more cpu then on path /proc/<pid>/cpuset find containerID then on path /sys/fs/cgroup/system.slice/<containerID>
## SonarQube
   Create Key On Sonarqube
   Install Plugins On Jenkins
   1) go to managejenkins
   2) Section SonarQube servers
   3) Put Ip Address Sonar
   4) Put Key On Credentials
   stage('Sonarqube'){ 
     steps{ 
        withSonarQubeEnv('Sonar-Server-8.9.2'){ 
          sh ''' gradle sonar ''' 
                }
            }
        }
