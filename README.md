# Cloud Engineer Hands-On Project: Three-Tier App Deployment on AWS & Kubernetes

## Project Overview & Architecture
This project is a 100% Free Tier safe cloud infrastructure and automated CI/CD pipeline implementation. Its primary objective is to eliminate manual deployment processes and achieve zero-touch cloud automation, ensuring that code pushes automatically trigger builds and deployments to Kubernetes.

* **Cloud Provider:** AWS Free Tier (VPC, t2.micro EC2, Security Groups)
* **Infrastructure as Code (IaC):** HashiCorp Terraform
* **Containerization:** Docker
* **Orchestration:** Lightweight Kubernetes (Minikube / K3s)
* **CI/CD Automation:** GitHub Actions
* **Cost Assurance:** Zero billing risk (Avoids paid services like AWS EKS)

---

## Architecture Flow
1. **Infrastructure Provisioning (Terraform):** Automates the creation of a custom VPC (10.0.0.0/16), Public Subnet, Internet Gateway, Route Table, and Security Groups (allowing SSH port 22 and HTTP port 80). It also provisions a free-tier eligible Ubuntu t2.micro EC2 instance.
2. **Containerization (Docker):** Application workloads are packaged into isolated Docker containers.
3. **Orchestration (Kubernetes):** Containers are managed and orchestrated on the EC2 server using a lightweight Kubernetes setup (Minikube/K3s).
4. **CI/CD Pipeline (GitHub Actions):** Whenever a developer pushes code to the main branch, the GitHub Actions workflow triggers automatically. It builds and pushes the image to Docker Hub, then securely connects to the EC2 instance via SSH to update the Kubernetes deployment (`kubectl rollout restart`).

## ⚙️ How to Setup & Run (K3s & Kubernetes Commands Guide)
Agar aapko is project ko apne server par manually set up karna pade, toh aap in step-by-step commands ka use kar sakte hain:

### 1. K3s Installation
AWS EC2 server par lightweight Kubernetes (K3s) download aur install command.
```bash
curl -sfL https://get.k3s.io | sh -
### 2. Check Cluster Status (Nodes)
Run this command after installation to verify that the cluster is active, healthy, and the status shows Ready:
```bash
sudo kubectl get nodes
### 3. Restart K3s Service
Agar kabhi K3s ki service ko restart karna pade, toh yeh command use hoti hai:
```bash
sudo systemctl restart k3s
### 6. Uninstall K3s (Cleanup)
Agar kabhi pura setup hata kar server ko clean karna ho, toh is script ka use hota hai:
```bash
sudo /usr/local/bin/k3s-uninstall.sh