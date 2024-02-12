The terraform code will create follwoing components:
- VPC
- subnets for each Availabilty zone
- route tables
- 3 public subnets
- 3 private subnets
- application load balancer
    - a security group for ALB
- listener rules (inside the ALB) 
- Internet Gateway
- NAT Gateway (inside the public subnet)
- Bastion host (inside the public subnet)

- Security group

- 1st tier: 
    - frontend auto scaling group (inside the private subnets)
- 2nd tier:
    - backend auto scaling group (inside the private subnets)
- 3rd tier:
    - AWS RDS (inside the private subnets)

- it will also create a secret in secrets manager to store the credentials of the RDS.