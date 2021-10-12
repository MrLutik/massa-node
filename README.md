### massa-node
Config file and a little instruction on building and deploying container with massa-node

To put your node in container you should clone the source into your host machine
```
git clone https://github.com/MrLutik/massa-node.git
```
Enter the new directory
```
cd massa-node
```
Give correct permission to docker installation script
```
chmod +x docker-install.sh
```
Start the script
```
./docker-install.sh
```
Build an image 
```
docker build --tag massa-node .
```
Start the container from the created image
```
docker run -d --rm --network host --name massa-node -v "path_to_your_keys:/massa/massa-node/config" massa-node
```
