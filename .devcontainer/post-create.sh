#!/bin/bash

# this runs at Codespace creation - not part of pre-build

echo "$(date)    post-create start" >> ~/status

#Install jq
apt update
apt install -y jq

#Install Helm
curl -fsS "https://get.helm.sh/helm-v3.10.2-linux-amd64.tar.gz" -o /tmp/helm.tar.gz
tar -zxf /tmp/helm.tar.gz -C /tmp linux-amd64/helm
sudo mv /tmp/linux-amd64/helm /usr/local/bin
rm -f /tmp/helm.tar.gz
rm -rf /tmp/linux-amd64

#Install envsubst
curl -Lso envsubst https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-Linux-x86_64
sudo install envsubst /usr/local/bin
rm -rf ./envsubst

#Install Task
sudo sh -c "$(curl -sL https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

#Install skaffold
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
sudo install skaffold /usr/local/bin/
rm -rf skaffold

#Install Istioctl
VERSION=`curl --silent "https://api.github.com/repos/istio/istio/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`
curl -sSL "https://github.com/istio/istio/releases/download/${VERSION}/istio-${VERSION}-linux-amd64.tar.gz" -o /tmp/istio.tar.gz
tar -xf /tmp/istio.tar.gz -C /tmp
sudo mv /tmp/istio-${VERSION}/bin/istioctl /usr/local/bin
rm -f /tmp/istio-${VERSION}.tar.gz
rm -rf tmp/istio-${VERSION}

#Install Flux
VERSION=`curl --silent "https://api.github.com/repos/fluxcd/flux2/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'`
curl -Ls "https://github.com/fluxcd/flux2/releases/download/v${VERSION}/flux_${VERSION}_linux_amd64.tar.gz" -o /tmp/flux2.tar.gz
tar -xf /tmp/flux2.tar.gz -C /tmp
sudo mv /tmp/flux /usr/local/bin
rm -f /tmp/flux2.tar.gz

#Install az extensions
sudo az aks install-cli -y
sudo az extension add --name application-insights -y
sudo az extension add --name aks-preview -y

echo "$(date)    post-create complete" >> ~/status
