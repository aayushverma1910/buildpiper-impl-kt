# BuildPiper EKS Infrastructure - Terraform

This Terraform project provisions a complete EKS infrastructure for the `buildpiper` project in the `dev` environment using AWS. It includes networking, VPC peering, subnets, security groups, and an EKS cluster with node groups.

---

## 📍 Region

- **AWS Region:** `eu-north-1`
- **Environment:** `dev`
- **Project Name:** `buildpiper`
- **Owner:** `aayush`

---

## 🏗️ VPC Configuration

- **CIDR Block:** `192.168.0.0/24`
- **DNS Support:** Enabled
- **DNS Hostnames:** Enabled
- **Instance Tenancy:** `default`
- **EIP Domain:** `vpc`

---

## 🌐 Subnets

| Name              | CIDR Block        | Availability Zone |
|-------------------|-------------------|--------------------|
| public-sub1       | 192.168.0.0/28    | eu-north-1a        |
| public-sub2       | 192.168.0.32/28   | eu-north-1b        |
| application-sub1  | 192.168.0.16/28   | eu-north-1a        |
| application-sub2  | 192.168.0.64/27   | eu-north-1b        |
| database-sub1     | 192.168.0.48/28   | eu-north-1a        |
| database-sub2     | 192.168.0.96/28   | eu-north-1b        |

---

## 🚦 Route Tables

- **Public Route Table CIDR:** `0.0.0.0/0`
- **Private Route Table CIDR:** `0.0.0.0/0`
- **Public Subnet Indexes:** `[0, 5]` (public-sub1 and public-sub2)

---

## 🔗 VPC Peering Configuration

- **Peering Connection:** `true`
- **Peer Region:** `eu-north-1`
- - **Use Same Account:** `true`
- **Peer Owner ID:** `863518439597` # if you want to peering in diff acc then false this value `use_same_account` and mention that `Peer Owner ID`
- **VPC Name (Manage):** `manage-buildpiper-vpc` #value fetch using data block
- **Route Tables for Peer VPC:**
  - Public RT: `manage-buildpiper-public-rt`  #value fetch using data block
  - Private RT: `manage-buildpiper-private-rt` #value fetch using data block
- **Hardcoded Peering Support:** Available (toggle with `use_hardcoded_value`)

```bash
use_hardcoded_value  = true
hardcoded_vpc_id     = "vpc-0b2f7d89d33499a95"
hardcoded_vpc_cidr   = "10.0.0.0/21"
hardcoded_public_rt  = "rtbassoc-023173896b4bf6a0d"
hardcoded_private_rt = "rtbassoc-03562b61f6511567f"
peer_region          = "eu-north-1"
use_same_account     = true
peer_owner_id        = "863518439597"

```


---

## 🔐 Security Groups

### ➤ Application Node SG
- **Ingress:**
  - All traffic from `0.0.0.0/0`
  - Port 443, 10250 from `eks-cluster` SG
- **Egress:** All outbound to `0.0.0.0/0`

### ➤ Database Node SG
- **Ingress:**
  - All traffic from `0.0.0.0/0`
  - Port 443, 10250 from `eks-cluster` SG
- **Egress:** All outbound to `0.0.0.0/0`

### ➤ EKS Cluster SG Rules
- Allow TCP:
  - Port 443
  - Port 10250
  - Port Range 1024–65535

---

## ☸️ Amazon EKS Cluster

- **Version:** `1.32`
- **Private Endpoint Access:** Yes
- **Public Endpoint Access:** No
- **IAM Roles:**
  - Cluster Role: `eks-cluster-roles`
  - Node Role: `eks-node-roles`

### 📦 AMI & Key

- **AMI Type:** `AL2023_x86_64_STANDARD`
- **Key Pair:** `eks`

---

## 📤 Node Groups

### ➤ Application Node Group

- **Capacity Type:** `ON_DEMAND`
- **Instance Type:** `t3.medium`
- **Desired / Min / Max Size:** 1 / 1 / 2
- **EBS Volume:** 25 GB `gp2`
- **Taint:** `dedicated=application:NoSchedule`
- **Public IP:** No

### ➤ Database Node Group

- **Capacity Type:** `ON_DEMAND`
- **Instance Type:** `t3.medium`
- **Desired / Min / Max Size:** 1 / 1 / 2
- **EBS Volume:** 25 GB `gp2`
- **Taint:** `dedicated=database:NoSchedule`
- **Public IP:** No

---

## ✅ IAM Policy ARNs

### ➤ Cluster Role
- `AmazonEKSClusterPolicy`

### ➤ Node Role
- `AmazonEKSWorkerNodePolicy`
- `AmazonEKS_CNI_Policy`
- `AmazonEC2ContainerRegistryReadOnly`

---

## 🚀 Deployment

Make sure your AWS CLI is configured, and then:

```bash
terraform init
terraform plan
terraform apply
