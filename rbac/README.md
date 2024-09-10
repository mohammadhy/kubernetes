     [!TIP] 
     {% raw %}Name Organaziation must be same as namespace

    openssl genrsa -out devuser.key 2048
    openssl req -new -key devuser.key -out devuser.csr -subj "/CN=devuser/O=develop"
    sudo openssl x509 -req -in devuser.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out devuser.crt -days 3650
    kubectl config set-credentials devuser --client-certificate devuser.crt --client-key devuser.key
    kubectl config set-context devuser-context --cluster=cluster.local --namespace=develop --user=devuser
    kubectl get po --context devuser-context
    # See Error Here Error from server (Forbidden): pods is forbidden: User "devuser" cannot list resource "pods" in API group "" in the namespace "develop"
    
