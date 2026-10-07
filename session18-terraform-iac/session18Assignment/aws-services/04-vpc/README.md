# VPC - Virtual Private Cloud

## What is VPC?
A VPC is your own private network inside AWS. Your EC2 instances, databases etc. live inside it.
The way I think of it: AWS is a huge city and the VPC is my own gated colony with my own roads and gates.
Every region gives you a default VPC, but for real projects you make your own.
Next session I'm building one with Terraform: `10.0.0.0/16`.

## CIDR
CIDR is how you write an IP range. The number after the slash = how many bits are fixed.
Smaller number = bigger network. /16 = 65,536 IPs, /24 = 256 IPs.
A VPC can be between /16 and /28.

My plan for next session:

```
VPC          10.0.0.0/16    -> 10.0.0.0 to 10.0.255.255   (65,536 IPs)
  public     10.0.1.0/24    -> 10.0.1.0 to 10.0.1.255     (256 IPs, 251 usable)
  private    10.0.2.0/24    -> 10.0.2.0 to 10.0.2.255     (256 IPs, 251 usable)
```

AWS reserves 5 IPs in every subnet (first 4 + last 1), that's why it's 251 not 256.

## Subnets
A subnet is a smaller chunk of the VPC's IP range.
Each subnet lives in exactly one Availability Zone (e.g. ap-south-1a).
For high availability you spread subnets across 2+ AZs.

## Route tables
A route table tells traffic where to go. Every subnet is associated with one.
Every route table has a `local` route so things inside the VPC can talk to each other.
Example route: `0.0.0.0/0 -> igw-xxxx` means "anything going to the internet, send to the internet gateway".

## Internet Gateway
The IGW is the door between the VPC and the internet.
One IGW per VPC, you attach it and then add a route to it. It's free.
Without it nothing in the VPC can reach the internet (or be reached).

## NAT Gateway
Lets instances in a private subnet go OUT to the internet (like for `apt update`) but nobody can come IN.
It sits in a public subnet and the private subnet's route table points `0.0.0.0/0` to it.
It costs money every hour + per GB of data, so I delete it after practice. Not using it next session.

## Security Groups
Firewall at the instance (ENI) level. Only allow rules.
Stateful: if inbound is allowed, the response goes back out automatically.
Next session my SG allows port 80 inbound so I can hit the nginx page.

## Network ACLs
Firewall at the subnet level. Has both allow and deny rules.
Stateless: you have to allow both inbound AND outbound (including ephemeral ports 1024-65535 for replies).
Rules are numbered and checked lowest number first, first match wins. The default NACL allows everything.

Quick comparison:

| | Security Group | NACL |
|---|---|---|
| Level | Instance | Subnet |
| Rules | Allow only | Allow + Deny |
| State | Stateful | Stateless |
| Order | All rules checked | Numbered, first match wins |

## Public vs private subnet
There's no "public" checkbox, it's all about the route table.
Public subnet = route table has `0.0.0.0/0 -> Internet Gateway`. Instances there can have public IPs.
Private subnet = no route to the IGW (maybe a route to a NAT gateway instead).
Usual setup: web servers / load balancers in public, databases in private.
My t3.micro nginx box will go in the public subnet so I can open it in a browser.

What I learned:
A VPC is just my own network. Subnets split it up, route tables decide where traffic goes,
and the internet gateway is what makes a subnet "public". SGs protect instances, NACLs protect subnets.
