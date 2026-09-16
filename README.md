# AWS High-Availability & Custom-Metric Auto-Scaling Backend

## 📌 Project Overview

This project demonstrates a highly available, horizontally scalable backend infrastructure built on AWS. The architecture uses multiple Availability Zones, an Application Load Balancer, RHEL-based EC2 instances, Auto Scaling, CloudWatch custom metrics, and SNS notifications.

The objective is to automatically scale the infrastructure based on **RAM utilization** while maintaining availability during increased workloads and reducing resources when demand decreases.

---

## 🏗️ Architecture

```text
                         Internet
                            │
                            ▼
                 ┌─────────────────────┐
                 │ Application Load    │
                 │ Balancer (ALB)      │
                 └──────────┬──────────┘
                            │
              ┌─────────────┴─────────────┐
              │                           │
              ▼                           ▼
       ┌─────────────┐             ┌─────────────┐
       │ RHEL EC2    │             │ RHEL EC2    │
       │ Instance    │             │ Instance    │
       │ AZ: 1a      │             │ AZ: 1b      │
       └──────┬──────┘             └──────┬──────┘
              │                           │
              └─────────────┬─────────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │ Auto Scaling Group  │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │ CloudWatch Agent    │
                 │ Memory Metrics      │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │ CloudWatch          │
                 │ CWAgent Namespace   │
                 └──────────┬──────────┘
                            │
                            ▼
                 Target Tracking Policy
                    (Memory ~ 70%)
                            │
                    ┌───────┴───────┐
                    ▼               ▼
                Scale Out        Scale In

                       ┌─────────────┐
                       │     SNS     │
                       │ Notifications│
                       └─────────────┘
```

---

## ☁️ AWS Services Used

* **Amazon VPC** – Network isolation and subnet configuration
* **Amazon EC2** – RHEL-based compute instances
* **Application Load Balancer** – Distributes incoming traffic
* **Auto Scaling Group** – Automatically adds/removes instances
* **Launch Template** – Defines EC2 configuration for scaling
* **Amazon CloudWatch** – Monitoring and custom metrics
* **CloudWatch Agent** – Collects system-level memory utilization
* **Amazon SNS** – Sends scaling event notifications
* **Security Groups** – Controls inbound and outbound traffic
* **Availability Zones** – Provides infrastructure fault tolerance

---

## ⚙️ How It Works

### 1. VPC & Networking

The infrastructure is deployed inside an AWS VPC across multiple Availability Zones.

The network includes the required subnets, route configuration, and Security Groups for communication between the load balancer and EC2 instances.

### 2. RHEL EC2 Instances

RHEL-based EC2 instances are launched using an **Auto Scaling Group** and configured through a Launch Template.

The instances run the backend/web workload and are registered with the ALB target group.

### 3. Application Load Balancer

The ALB acts as the public entry point.

Incoming requests are distributed across healthy EC2 instances, allowing the application to continue serving traffic when individual instances become unavailable.

### 4. CloudWatch Custom Memory Metrics

By default, EC2 monitoring does not provide the required in-guest memory utilization metric.

The **Amazon CloudWatch Agent** is installed and configured on the RHEL instances to collect:

```text
mem_used_percent
```

The metric is published under the:

```text
CWAgent
```

namespace.

### 5. Target Tracking Auto Scaling

The Auto Scaling Group uses the custom memory metric for target tracking.

A target such as:

```text
70% average memory utilization
```

can be configured.

When workload increases and the average memory utilization rises, the Auto Scaling Group can launch additional EC2 instances.

When demand decreases, the Auto Scaling Group can remove excess instances.

### 6. Load Testing

Workload can be generated on the RHEL instances to simulate increased resource utilization.

For example, controlled CPU/memory stress testing can be used to observe:

```text
Higher workload
      ↓
Higher memory utilization
      ↓
CloudWatch metric
      ↓
ASG scaling decision
      ↓
New EC2 instance
      ↓
ALB distributes traffic
```

### 7. SNS Notifications

Amazon SNS is integrated with scaling events to provide email notifications when instances are launched or terminated.

Example events:

```text
EC2 Instance Launch
EC2 Instance Termination
```

This provides additional operational visibility into Auto Scaling activity.

---

## 🔄 Scaling Flow

### Scale Out

```text
Increased workload
        ↓
Higher RAM utilization
        ↓
CloudWatch Agent
        ↓
Custom CloudWatch Metric
        ↓
Target Tracking Policy
        ↓
Auto Scaling Group
        ↓
New RHEL EC2 Instance
        ↓
ALB adds healthy instance
```

### Scale In

```text
Reduced workload
        ↓
Lower RAM utilization
        ↓
CloudWatch Metric
        ↓
Target Tracking Policy
        ↓
Auto Scaling Group
        ↓
Excess EC2 instance terminated
```

---

## 🔐 Security

The project uses AWS Security Groups to control network access.

Typical configuration includes:

* HTTP/HTTPS access through the Application Load Balancer
* Restricted SSH access for administration
* Controlled communication between ALB and EC2 instances
* Private resources where appropriate

---

## 🎯 Key Learning Outcomes

Through this project, I gained hands-on experience with:

* AWS VPC networking
* EC2 and RHEL administration
* Application Load Balancer
* Auto Scaling Groups
* Launch Templates
* CloudWatch monitoring
* CloudWatch Agent
* Custom CloudWatch metrics
* Target Tracking Scaling
* SNS notifications
* High availability architecture
* Infrastructure troubleshooting
* Linux workload monitoring

---

## 🛠️ Technologies

**Cloud:** AWS
**Compute:** EC2
**OS:** Red Hat Enterprise Linux (RHEL)
**Networking:** VPC, Subnets, Security Groups, Route Tables
**Load Balancing:** Application Load Balancer
**Scaling:** Auto Scaling Group, Target Tracking
**Monitoring:** CloudWatch, CloudWatch Agent
**Notifications:** Amazon SNS

---

## 📷 Project Screenshots

Add screenshots here showing:

1. VPC architecture
2. EC2 instances
3. Application Load Balancer
4. Auto Scaling Group
5. CloudWatch `mem_used_percent` metric
6. Auto Scaling activity/history
7. SNS notification
8. RHEL terminal/configuration

---

## 👨‍💻 Author

**Shubham Dixit**

AWS Cloud | Linux/RHEL | Cloud Infrastructure | IT Operations
