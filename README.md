# Portainer Install Ubuntu tutorial - manage your docker containers
Portainer is a powerful, free, and open-source tool designed to simplify the management of Docker containers. With its clean and intuitive web UI, you can easily inspect and control all your Docker resources. This tutorial will guide you through the steps to install Portainer on an Ubuntu server.

## Overview

Portainer CE (Community Edition) is a lightweight management UI that allows you to manage your Docker environments with ease. It supports a wide range of Docker features and provides a centralized interface for managing containers, images, networks, and volumes.

**Project Homepage:** [Portainer.io](https://www.portainer.io)  
**Documentation:** [Portainer Docs](https://docs.portainer.io)  
**Video Tutorial:** [Watch on YouTube](https://youtu.be/ljDI5jykjE8)

---

## Prerequisites

- A Linux server running **Ubuntu 20.04 LTS** or newer.
- Basic knowledge of Linux commands.

> **Note:** While this guide focuses on Ubuntu, you can install Docker on other Linux distributions. However, the commands may vary.

---

## Step 1: Set Up Portainer

### 1.1 Create a Docker Volume for Portainer
```bash
docker volume create portainer_data
```

### 1.2 Launch Portainer
Run the following command to start Portainer:
```bash
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

Portainer will now be accessible via your server's IP address on port `9000`. Open your browser and navigate to `http://<your-server-ip>:9000` to complete the setup.

---

## Additional Notes

For advanced setups, such as using Portainer with Docker Swarm or Kubernetes, refer to the [official documentation](https://docs.portainer.io).

---

## Load Balancing with NGINX

To distribute traffic across multiple backend servers, you can configure NGINX as a load balancer. Below is an example configuration using the **round-robin** and **least connections** methods:

### NGINX Configuration Example
```nginx
events {
    worker_connections  1024;
}
http {
    # Load balancing using least connections
    upstream backend {
        least_conn;
        server first-nginx-container;
        server second-nginx-container;
        server third-nginx-container;
    }

    server {
        listen       80;

        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

### Explanation of Load Balancing Methods

1. **Round-Robin**: This is the default load balancing method in NGINX. It distributes requests sequentially to each server in the upstream group. For example, the first request goes to `first-nginx-container`, the second to `second-nginx-container`, and so on. Once all servers have received a request, the cycle repeats.

2. **Least Connections**: This method directs traffic to the server with the fewest active connections. It is particularly useful when backend servers have varying workloads or processing speeds, as it ensures a more balanced distribution of traffic.

You can choose the method that best suits your application's needs by modifying the `upstream` block in the NGINX configuration.

Happy container management and load balancing!
