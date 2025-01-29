# 🚀 Jenkins CI/CD Setup on AWS EC2

## 🖥️ Step 1: Create and Configure EC2 Instance

### Launch an EC2 Instance

- Choose **Ubuntu** as the OS.
- Ensure **internet access** and a **public IP**.

### Update the System

```sh
sudo apt update
```

### Install Java

```sh
sudo apt install openjdk-11-jre -y
```

### Install Jenkins

```sh
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install jenkins -y
```

### Start and Enable Jenkins

```sh
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
```

### Allow Jenkins Port in EC2 Security Group

Edit Inbound Rules in your EC2 security group and add the following rule:

- **Type**: Custom TCP Rule
- **Port Range**: 8080
- **Source**: `0.0.0.0/0` (or your IP for security)

### Retrieve Jenkins Admin Password

To log in to Jenkins, run the following command and copy the password:

```sh
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

You will get this from Jenkins login page itself: `/var/lib/jenkins/secrets/initialAdminPassword`

Paste this password into the Jenkins UI at: `http://<EC2_PUBLIC_IP>:8080`

## 🎯 Create a New Jenkins Job

### Go to Jenkins Dashboard → New Item

- Select **"Freestyle project"** → Click **OK**

### General Settings

- Check **GitHub Project** and enter your GitHub repository URL.

### Source Code Management (Git Integration)

Generate an SSH key pair for authentication:

```sh
ssh-keygen
```

View the keys:

```sh
cd ~/.ssh
cat id_rsa.pub  # Public Key
cat id_rsa      # Private Key
```

#### Add SSH Key to GitHub

- Go to **GitHub → Settings → SSH Keys → New Key**
- Name it appropriately.
- Paste the SSH public key (`id_rsa.pub`).

#### Configure Jenkins for Git Integration

- In **Jenkins → Source Code Management → Git**, enter the repository URL.
- Add credentials:
  - **Domain**: Global
  - **Kind**: SSH Username with Private Key
  - **ID**: (Any unique name)
  - **Description**: (Optional)
  - **Username**: (Your EC2 machine username)
  - **Private Key**: Paste contents of `id_rsa`.
- Select the branch and save the configuration.

## 🐳 Install Docker in EC2 Instance

```sh
sudo apt install docker.io -y
```

## 🔗 Implement GitHub Webhook for CI/CD

### Install GitHub Integration Plugin

- **Jenkins Dashboard → Manage Jenkins → Manage Plugins**
- Search for **GitHub Integration Plugin**
- Install **without restart**

### Configure Webhook in GitHub Repository

- **GitHub → Repo Settings → Webhooks → Add Webhook**
- **Payload URL**: `http://<JENKINS_PUBLIC_IP>:8080/github-webhook/`
- **Content Type**: `application/json`
- **Trigger**: Just the **Push Event**
- Activate & Save
- Wait until webhook activates

### Enable GitHub Hook Trigger in Jenkins

- **Jenkins Job → Configure → Build Triggers**
- Check **"GitHub hook trigger for GITScm polling"**
- Save

## 🎉 Jenkins is Now Ready!

Now, whenever you push changes to GitHub, Jenkins will automatically trigger the build and deploy your application!