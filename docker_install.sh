apt update -y
#Install packages to use repos
apt install apt-transport-https ca-certificates curl gnupg lsb-release -y

#Add official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

apt update -y
apt install docker-ce docker-ce-cli containerd.io -y

