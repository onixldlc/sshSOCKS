
# sshSOCKS
sshSOCKS (SSH + MicroSOCKS) is a proxy server that forwards traffic through SSH tunnels, allowing you to access remote networks without connecting your entire device to them directly. sshSOCKS uses SOCKS5 to forward your traffic to an environment that's connected to the remote network via SSH instead!

With sshSOCKS, you can create as many instances as you want, and connect each of them to different SSH servers, giving you the option to switch between networks without actually having to reconnect. This, combined with [SwitchyOmega](https://github.com/FelisCatus/SwitchyOmega), can be powerful in situations where you need to interact with multiple systems deployed behind various SSH accessible servers. Instead of each browser having its own connection, you can have 1 browser with multiple connections to different tabs!

## Usage
### docker run
To quickly run sshSOCKS with default configuration, you can use this command:
```sh
sudo docker run  \
  -v ${PWD}/ssh.key:/etc/ssh/ssh.key \
  --cap-add=NET_ADMIN -p 1080:1080 \
  -e CONFIG_USERNAME=root \
  -e CONFIG_HOSTS=127.0.0.1 \
  --rm -it onixldlc/sshsocks:latest
```

### docker compose
Or if you prefer to use docker compose, you can fill the docker-compose.yml file like this:
```yml
services:
  opnsock:
    image: onixldlc/sshsocks:latest
    cap_add:
      - NET_ADMIN
    ports:
      - "1080:1080"
    volumes:
      - ./ssh.key:/etc/ssh/ssh.key        # optional
      # - ./client.ovpn:/client.ovpn      # optional, if config path is used
    environment:
      # SSH configuration options
      - CONFIG_HOSTS=127.0.0.1
      - CONFIG_USERNAME=root
      - CONFIG_PATH=./ssh.key             # optional
      - CONFIG_BASE64=${CONFIG_BASE64}    # optional

      # MicroSOCKS configuration options
      - MICROSOCKS_USER=test              # optional
      - MICROSOCKS_PASSWORD=test          # optional
      - MICROSOCKS_AUTHONCE=true          # optional
      - MICROSOCKS_LISTEN_IP=0.0.0.0      # optional
      - MICROSOCKS_WHITELIST=10.10.10.10  # optional
      - MICROSOCKS_BINDIP=0.0.0.0         # optional
      - MICROSOCKS_PORT=1080              # optional
      - MICROSOCKS_QUIET=false            # optional
      
      # Optional bandwidth limitations
      - BANDWIDTH=1mbit                   # optional
      - INTERFACE=eth0                    # optional
```

Then run the compose by using:
```
sudo docker compose up -d
```