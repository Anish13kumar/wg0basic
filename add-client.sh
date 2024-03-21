#!/bin/bash
sudo tee /etc/sudoers.d/$USER <<END
END
peer="peer-"$(expr $(cat lastpeer.txt | tr "-" " " | awk '{print $2}') + 1)
echo "Creating client config for: $peer"
mkdir -p clients/$peer
wg genkey | tee clients/$peer/$peer.priv | wg pubkey > clients/$peer/$peer.pub
wg genpsk > clients/$peer/$peer.psk
key=$(cat clients/$peer/$peer.priv)
key2=$(cat clients/$peer/$peer.pub)
ip="172.27.0."$(expr $(cat last-ip.txt | tr "." " " | awk '{print $4}') + 1)
cat wg0-client.example.conf | sed -e 's/:CLIENT_IP:/'"$ip"'/' | sed -e 's|:CLIENT_KEY:|'"$key"'|' | sed -e 's|:PSK_KEY:| '"$psk"'|' > clients/$peer/$peer.conf
echo $ip > last-ip.txt
echo $peer > lastpeer.txt
echo "Created config!"
echo "Adding peer"
cmt="#$1"
a="[Peer]"
b="PublicKey"
d="AllowedIPs"
e=$(cat last-ip.txt)
echo '' | sudo tee -a /etc/wireguard/wg0.conf
echo $a |  sudo tee -a /etc/wireguard/wg0.conf
echo $cmt | sudo tee -a /etc/wireguard/wg0.conf
echo $d "=" $e/32 | sudo  tee -a /etc/wireguard/wg0.conf
echo $b "=" $key2 | sudo  tee -a /etc/wireguard/wg0.conf

