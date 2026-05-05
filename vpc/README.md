# VPC Comparison: IGW-only vs NAT Gateway

This directory demonstrates two common VPC routing patterns.

---

## Setup 1 — IGW Only (`igw-vpc`)

**Directory:** `vpc/terraform/`

```
igw-vpc (10.0.0.0/16)
└── public-subnet (10.0.1.0/24)
      └── route table → Internet Gateway (0.0.0.0/0)
```

### How traffic flows
- Resources in the public subnet get a **public IP** assigned automatically (`map_public_ip_on_launch = true`)
- Traffic goes **directly** to/from the internet via the IGW
- The internet can also reach those resources directly (inbound allowed)

### Use this for
- Resources that need to be publicly reachable (web servers, load balancers, bastion hosts)
- Simple setups where cost matters — IGW is free

---

## Setup 2 — NAT Gateway (`nat-vpc`)

**Directory:** `nat-gateway/terraform/`

```
nat-vpc (10.0.0.0/16)
├── public-subnet (10.0.1.0/24)
│     └── NAT Gateway (holds the EIP: 54.145.64.172)
└── private-subnet (10.0.2.0/24)
      └── route table → NAT Gateway (0.0.0.0/0)
```

### How traffic flows
- Resources in the **private subnet** have no public IP
- Outbound traffic goes: private subnet → NAT GW → IGW → internet
- The internet **cannot initiate** connections into the private subnet
- The NAT Gateway has a fixed public IP (Elastic IP)

### Use this for
- App servers or databases that need to pull updates/packages but must not be directly reachable
- Any resource that should be hidden from the internet

---

## Side-by-side comparison

| | IGW Only | NAT Gateway |
|---|---|---|
| Resources have public IP | Yes (auto-assigned) | No (private only) |
| Inbound from internet | Yes | No |
| Outbound to internet | Yes | Yes (via NAT) |
| Cost | Free | ~$32/month per NAT GW |
| Typical use | Public-facing resources | App servers, databases |

---

## Key rule

> The NAT Gateway itself **must live in the public subnet** so it can reach the internet via the IGW. The private subnet routes to the NAT GW, not directly to the IGW.

```
Private EC2 → private-rt → NAT GW (public subnet) → IGW → Internet
                                ↑
                          needs the IGW to work
```
