Secure Cloud Vault (Infrastructure as Code)

This project defines a secure-by-design cloud storage environment using Terraform. It provisions an immutable AWS S3 vault designed to receive encrypted backups from on-premise Linux servers.

Unlike standard bucket creation, this infrastructure implements Zero Trust principles and Defense in Depth strategies to protect against ransomware and data exfiltration.

Integration: This infrastructure is the destination for the Hardened Backup Agent.

Security Features

Immutable History: S3 Versioning is enabled to allow recovery from accidental deletions or ransomware encryption attacks.

Encryption at Rest: Enforces Server-Side Encryption (AES-256) for all objects.

Least Privilege Access: Creates a dedicated IAM Service Account (backup_bot) with permissions restricted strictly to PutObject and ListBucket on this specific vault.

Public Access Block: Explicitly denies all public read/write ACLs at the bucket level.

Technology Stack

Terraform: v1.0+

Cloud Provider: AWS

OS: Developed on Arch Linux

Deployment Guide

Prerequisites

Arch Linux: sudo pacman -S terraform aws-cli

AWS Account with Admin Access Keys configured.

Quick Start

Clone the repository:

git clone [https://github.com/yourusername/secure-cloud-vault.git](https://github.com/yourusername/secure-cloud-vault.git)
cd secure-cloud-vault


Initialize Terraform:

terraform init


Deploy Infrastructure:

terraform apply


Capture Credentials:
Terraform will output the bucket_name, access_key, and secret_key. Save these immediately to configure the Backup Agent.