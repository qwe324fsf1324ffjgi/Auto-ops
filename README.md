# 🚀 AutoOps — Self-Healing Infrastructure on AWS

[![AutoOps Demo](https://drive.google.com/uc?export=view&id=1f4ILSHDHC68EgIOY4fEPFMbNnjxJd2_j)](https://drive.google.com/file/d/1FNkHqzuApdedPl_IpVzsbse_Q0fme_ld/view?usp=drivesdk)

<p align="center">
  <a href="https://drive.google.com/file/d/1FNkHqzuApdedPl_IpVzsbse_Q0fme_ld/view?usp=drivesdk">
    <img src="https://img.shields.io/badge/▶-Watch%20Demo%20Video-success?style=for-the-badge" />
  </a>
</p>

AutoOps is a self-healing cloud system that automatically detects failure and fixes it without human intervention.

---

## 🔥 What This Project Does

- Runs an application on EC2  
- Monitors it using AWS Lambda  
- If the app fails → it is automatically restarted  
- Runs checks every 5 minutes using EventBridge  
- Fully deployed using Terraform  
- Automatically deployed with GitHub Actions  

---

## 🧠 How It Works

EC2 runs app  
↓  
Lambda checks app  
↓  
If broken → SSM restarts Docker  
↓  
EventBridge triggers Lambda every 5 mins  
↓  
GitHub Actions deploys everything automatically  

---

## 🧩 Architecture

```
GitHub Actions → Terraform → AWS

EventBridge → Lambda → Health Check  
                        ↓  
                     If broken  
                        ↓  
                     AWS SSM  
                        ↓  
                      EC2  
                        ↓  
              Restart Docker Container
```

---

## ⚙️ Tech Stack

- AWS EC2  
- AWS Lambda  
- AWS SSM  
- AWS EventBridge  
- Terraform  
- GitHub Actions  
- Docker + NGINX  
- Python  

---

## 📁 Project Structure

```
autoops/
├── terraform/
├── lambda/
├── scripts/
├── .github/workflows/
└── README.md
```

---

## 🚀 Setup (Windows PowerShell)

### 1. Install Tools

- Terraform  
- AWS CLI  
- Python  
- Git  

Verify:

```powershell
terraform -version
aws --version
python --version
git --version
```

---

### 2. Create Project

```powershell
cd $HOME\Desktop
mkdir autoops
cd autoops
mkdir terraform, lambda, scripts, .github\workflows
```

---

### 3. Create Lambda ZIP

```powershell
cd $HOME\Desktop\autoops\lambda
Compress-Archive -Path lambda_function.py -DestinationPath autoops_lambda.zip -Force
```

Verify:

```powershell
Expand-Archive autoops_lambda.zip test
```

Expected:

```
test/lambda_function.py
```

---

### 4. Configure AWS

```powershell
aws configure
aws sts get-caller-identity
```

Use:

```
Region: eu-north-1
```

---

### 5. Deploy Infrastructure

```powershell
cd $HOME\Desktop\autoops\terraform

terraform init
terraform validate
terraform plan
terraform apply
```

Type:

```
yes
```

---

### 6. Get EC2 IP

```powershell
terraform output
```

---

### 7. Test App

Open:

```
http://<EC2_PUBLIC_IP>
```

You should see:

```
NGINX welcome page
```

---

### 8. Test Lambda

- Go to AWS Console → Lambda  
- Run test  

Expected:

```
Application is healthy
```

---

### 9. Test Self-Healing

Stop container:

```bash
docker stop autoops-nginx
```

Wait ~5 minutes

Check:

```bash
docker ps
```

👉 Container should restart automatically

---

### 10. Setup GitHub

```powershell
cd $HOME\Desktop\autoops
git init
git add .
git commit -m "initial commit"
git remote add origin <repo-url>
git push -u origin main
```

---

### 11. Add GitHub Secrets

Add:

- AWS_ACCESS_KEY_ID  
- AWS_SECRET_ACCESS_KEY  
- AWS_REGION = eu-north-1  

---

### 12. Trigger CI/CD

```powershell
git push
```

Go to:

```
GitHub → Actions
```

---

## ⚠️ Common Errors

### Lambda zip not found
Fix:
```
Ensure lambda/autoops_lambda.zip exists
```

### Wrong ZIP structure
Fix:
```
Must contain lambda_function.py at root
```

### EC2 not loading
Check:
- Security group port 80  
- Instance running  
- Wait 2 mins  

### SSM not working
Fix:
```
Attach AmazonSSMManagedInstanceCore to EC2 role
```

---

## 🧠 What You Built

- Self-healing system  
- Event-driven automation  
- Infrastructure as Code  
- Cloud monitoring + auto recovery  

---

## 🎥 Demo

https://drive.google.com/file/d/1FNkHqzuApdedPl_IpVzsbse_Q0fme_ld/view?usp=drivesdk

---

## 🔥 Final

> I didn’t just deploy infrastructure… I built a system that fixes itself.
