#!/bin/bash

#定义变量
ports=(22 80 443 "60000:61000/udp")
certpath="/etc/letsencrypt/live/$domain/fullchain.pem"
keypath="/etc/letsencrypt/live/$domain/privkey.pem"

echo "Enter the domain you want to deploy or skip just enter:"
read domain

#instlal necicery
apt install mosh docker certbot
# 遍历端口数组并放行
for port in "${ports[@]}"; do
  ufw allow "$port"
done
echo "指定的端口已放行：${ports[@]}"

#获取ca的证书和密钥
if [ -z $domain ]; then
  echo "skip acme."
else
  echo "getting CA cert "
  certbot certonly --standalone -d ${domain} -d "www.${domain}"
fi

#配置trojan和hysteria
#docker way
#`docker run \
#    --name trojan-go \
#    -d \
#    -v /etc/trojan-go/:/etc/trojan-go \
#    --network host \
#    p4gefau1t/trojan-go
mkdir
trojan ~/trojan && cd ~/trojan
if {find . -maxdepth 1 type f -name "trojan*" | grep -q .}; then
  echo "trojan already exists"
else
  wget https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-linux-amd64.zip
  unzip trojan-go-linux-amd64.zip
fi
cp example/server.yaml .
cp $certpath .
cp $keypath .
