#!/bin/bash -xe
echo " K8S Node config start "

echo "[TASK 1] K8S Controlplane Join - API Server 192.168.56.103" 
kubeadm join --token 123456.1234567890123456 --discovery-token-unsafe-skip-ca-verification 192.168.56.103:6443

echo "[TASK 2] Config kubeconfig" 
mkdir -p /root/.kube
#sshpass -p "P@ssw0rd" scp -o StrictHostKeyChecking=no root@master:/etc/kubernetes/admin.conf /root/.kube/config

echo "[TASK 3] Alias kubectl to k"
echo 'alias k=kubectl' >> /etc/profile
echo 'complete -F __start_kubectl k' >> /etc/profile

echo "[TASK 4] Install Helm"
curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

echo " K8S Node config End "