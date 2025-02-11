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
    Check Selector By following command kubectl get prometheus.monitoring.coreos.com -o yaml 
    helm show values prometheus-community/kube-prometheus-stack > values.yaml
        alertmanagerConfigSelector:
       matchLabels:
         release: prometheus-stack
    helm upgrade prometheus-stack prometheus-community/kube-prometheus-stack -f values.yaml
    This is Simple ServiceMonitor:
    ------------------------------------
    apiVersion: monitoring.coreos.com/v1
    kind: ServiceMonitor
    metadata:
    labels:
      release: prometheus-stack
    name: servicemonitor-python-web-app
    namespace: stage
    spec:
      endpoints:
      - interval: 30s
        port: web
      selector:
        matchLabels:
         app: python-log
      namespaceSelector:
        matchNames:
        - stage

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
   5) EX For Python : /var/lib/jenkins/sonar-cli/bin/sonar-scanner -Dsonar.projectKey=<Project-Name> -Dsonar.sources=.  -Dsonar.exclusions=<file/folder not scan>
## Mysql-Operator
    kubectl apply -f https://raw.githubusercontent.com/mysql/mysql-operator/trunk/deploy/deploy-crds.yaml
    kubectl apply -f https://raw.githubusercontent.com/mysql/mysql-operator/trunk/deploy/deploy-operator.yaml
    Change storageclass to default
## Affinity 
    if you have 3 nodes and 3 replicas of pod and need to each pod assigns to differnet node add command below
        spec:
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: kubernetes.io/hostname
        whenUnsatisfiable: DoNotSchedule
        labelSelector:
          matchLabels:
            app: my-service
## Move Image Docker To Containerd:
    docker save -o image.tar <image-name>
    sudo scp IP:<PATH> image.tar
    sudo ctr -n=k8s.io images import image.tar
## Use Trivy Offline Scanner
    snap install oras --classic
    oras cp ghcr.io/aquasecurity/trivy-db:2 --to-plain-http 192.168.1.104:5000/trivy/trivy-db:2
    TRIVY_USERNAME=YOUR_USERNAME TRIVY_PASSWORD=YOUR_PASSWORD trivy image --db-repository 192.168.1.104:5000/trivy/trivy-db:2 -f json -o trivy.json 192.168.1.104:5000/python-web-app:v1 
## Use Loki & Grafana To Logging 
    helm repo add grafana https://grafana.github.iohelm-chart
    helm show values  grafana/loki-stack  > values.yaml Set Grafana: True
    helm install --values values.yaml loki grafana/loki-stack
    kubectl get secrets loki-grafana -o json {.data.admin-password} | base64 -d
    
## Use Metrics-server 
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml
    kubectl -n kube-system edit deployment metrics-server
    - --kubelet-insecure-tls
