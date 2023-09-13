#!/bin/bash -xe

echo "[TASK 1] Setting sshd config"
sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart ssh

echo "[Task 2] Change Timezone & Setting Profile"
# Change Timezone
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

echo "[TASK 3] Disable ufw" 
systemctl stop ufw && systemctl disable ufw

echo "[TASK 4] Install base Package"
apt update && apt install -y tree jq sshpass bridge-utils net-tools bat nfs-common sysstat
echo "alias cat='batcat --paging=never'" >> /etc/profile

echo "[TASK 5] Setting Local DNS Using Hosts file"
echo "192.168.56.103 master" >> /etc/hosts
echo "192.168.56.104 worker" >> /etc/hosts

echo "[TASK 6] docker install"
# docker gpg key add
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# docker repository add 
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# docker install
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

echo "[TASK 7] swwap memory off"
swapoff -a
sed -i '/swap/s/^/#/' /etc/fstab

echo "[TASK 8] edit iptables"
echo "net.bridge.bridge-nf-call-ip6tables = 1" | sudo tee /etc/sysctl.d/k8s.conf
echo "net.bridge.bridge-nf-call-iptables = 1" | sudo tee -a /etc/sysctl.d/k8s.conf
sudo sysctl --system

echo "[TASK 9] kubernetes install"
apt-get install -y apt-transport-https ca-certificates
sudo curl -s /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
rm /etc/containerd/config.toml
systemctl restart containerd
apt-get update
apt-get install -y kubelet kubeadm kubectl 
systemctl daemon-reload
systemctl restart kubelet

