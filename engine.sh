#!/bin/bash

#Docker engine-hez szükséges csomagok telepítése
username='ubuntu'
sudo apt-get update
sudo apt-get install nano git apt-transport-https -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
apt-cache policy docker-ce

#Docker engine telepítése
sudo apt-get install -y docker-ce
sudo systemctl status docker | grep docker.service

#Sudo jog beállítása
sudo usermod -aG docker $username && echo 'OK'

#Szükséges mappák létrehozása
cd ~
mkdir Docker
cd Docker
mkdir web

#Dockerfile létrehozása, szerkesztése
touch Dockerfile
cat <<EOF> Dockerfile
FROM nginx
COPY web /usr/share/nginx/html
RUN cd /usr/share/nginx/html/ && rm *
COPY web /usr/share/nginx/html
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
EOF

#HTML file létrehozása, szerkesztése
touch web/index.html
cat <<EOF> web/index.html
Sikeres vizsga!
EOF

#Docker image készítése, futtatása
cd ~
cd Docker
sudo docker build -t nginx .
sudo docker run -p 80:80 -d nginx
