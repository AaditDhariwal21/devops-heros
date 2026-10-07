# EC2 - Elastic Compute Cloud

## What is EC2?
EC2 gives you virtual servers in the cloud. You pick the OS, size and region and it's up in a minute.
The way I think of it: renting a computer in Amazon's data center by the hour (actually billed per second for Linux).
You can start and stop them whenever, so you only pay while it's running.

## AMI
AMI = Amazon Machine Image. It's the template the server boots from (OS + any preinstalled software).
Examples: Amazon Linux 2023, Ubuntu 22.04/24.04, Windows Server.
AMI IDs are different in every region, so the Ubuntu AMI in ap-south-1 has a different ID than in us-east-1.

## Instance types
Instance type = how much CPU and RAM you get. Name format is like `t3.micro`:
family (t = burstable general purpose), generation (3), size (micro).
Other families: m (general), c (compute heavy), r (memory heavy), g/p (GPU).
I'll use `t3.micro` next session because it's tiny and cheap (free tier eligible in many regions).

## Key pairs
Used to SSH into a Linux instance. AWS keeps the public key, you download the private key (.pem) once.
If you lose the .pem file you can't download it again.
Example: `ssh -i mykey.pem ubuntu@<public-ip>`

## Security Groups
A security group is a firewall around the instance.
You only write allow rules (no deny), e.g. allow port 22 from my IP, allow port 80 from anywhere.
They're stateful, so if a request comes in, the reply is allowed out automatically.
Next session my SG allows port 80 so I can open the nginx page in the browser.

## EBS
EBS = Elastic Block Store, basically the hard disk attached to the instance.
It's stored separately from the instance, so data survives a stop/start.
Common types: gp3 (general SSD, default choice), io2 (high IOPS), st1/sc1 (cheap HDD).
An EBS volume lives in one Availability Zone. You can take snapshots for backup (snapshots go to S3 behind the scenes).

## Public vs private IP
Private IP: used inside the VPC, stays the same for the life of the instance.
Public IP: used to reach it from the internet. The normal public IP changes when you stop and start.
If you need a fixed public IP, use an Elastic IP (note: AWS charges for all public IPv4 addresses now).

## Instance lifecycle

```
pending -> running -> stopping -> stopped -> (start again) -> pending -> running
running -> shutting-down -> terminated
```

- Stop = like shutting down a laptop, EBS data stays, no compute charge (still pay for the EBS disk).
- Reboot = restart, same IPs, same host.
- Terminate = deleted for good. Root EBS is deleted too by default.

## Common use cases
- Hosting web servers / APIs (like the nginx box I'm building next session).
- Jenkins or other CI servers.
- Running batch jobs or anything that needs a full server you control.
- Dev/test machines you can throw away after.

A couple of CLI commands I tried:

```bash
aws ec2 describe-instances --region ap-south-1
aws ec2 stop-instances --instance-ids i-0123456789abcdef0
```

What I learned:
EC2 is just a server you rent. AMI = what's on it, instance type = how big it is,
security group = who can talk to it, EBS = its disk. Always terminate stuff after practice so the bill doesn't grow.
