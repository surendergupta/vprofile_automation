# Vagrant vProfile Multi-Tier Java Application

## Overview
This project sets up a **multi-tier Java application** using **Vagrant** and **VirtualBox**. The architecture consists of multiple virtual machines, each serving a specific role in the deployment. Provisioning is automated using shell scripts for each server.

## Architecture
The multi-tier setup consists of the following servers:

1. **db01 (Database Server)** – Runs **MariaDB/MySQL** for storing application data.
2. **mc01 (Memcached Server)** – Provides caching to optimize performance.
3. **rmq01 (RabbitMQ Server)** – Handles messaging and queueing.
4. **app01 (Tomcat Application Server)** – Hosts the Java-based application.
5. **web01 (Nginx Reverse Proxy Server)** – Acts as a frontend load balancer.

## Prerequisites
Ensure you have the following installed on your machine:
- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [vagrant plugin install vagrant-hostmanager]

## Setup Instructions
1. Clone the repository:
   ```sh
   git clone https://github.com/surendergupta/vprofile_automation.git   
   cd vprofile_automation
   ```
2. Start the environment:
   ```sh
   vagrant up
   ```
3. Verify all machines are running:
   ```sh
   vagrant status
   ```
4. Use Project repository
    ```sh
    git clone https://github.com/surendergupta/vprofile-project.git
    ```
## Vagrant Configuration
The `Vagrantfile` defines all virtual machines and their configurations:

- **Networking:** Private network with static IPs.
- **Provisioning:** Automated using shell scripts (`scripts/*.sh`).
- **Resource Allocation:** Memory and CPU assigned per VM.

## Automation Scripts
Each VM has an automation script located in the `scripts/` directory:

- `scripts/db01.sh` – Installs and configures MariaDB/MySQL.
- `scripts/mc01.sh` – Sets up Memcached.
- `scripts/rmq01.sh` – Configures RabbitMQ.
- `scripts/app01.sh` – Deploys the Java application on Tomcat.
- `scripts/web01.sh` – Configures Nginx as a reverse proxy.

## Managing VMs
- To **access a specific VM**:
  ```sh
  vagrant ssh <vm-name>
  ```
- To **restart a VM**:
  ```sh
  vagrant reload <vm-name> --provision
  ```
- To **destroy all VMs**:
  ```sh
  vagrant destroy -f
  ```

## Testing the Application
1. After provisioning, access the application via:
   ```
   http://192.168.56.11
   ```
   (Replace with the correct IP of `web01` if different.)

## Troubleshooting
- If provisioning fails, try running:
  ```sh
  vagrant reload --provision
  ```
- To debug SSH issues:
  ```sh
  vagrant ssh-config
  ```

## Future Enhancements
- Implement in **AWS** for cloud infrastructure.
- Automate deployment with **Ansible**.
- Add **Docker** support.
- Implement **Kubernetes** for container orchestration.
- Integrate **Terraform** for infrastructure as code.
- Implement **CI/CD pipelines** for automated deployments.

## License
This project is licensed under the **MIT License**.

---

🚀 **Developed by Surender Gupta**

