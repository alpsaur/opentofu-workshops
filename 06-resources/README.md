Steps for implementation:
1. Deploy a VPC and subnet
2. Deplot an internet gateway and associate it to the VPC
3. Setup a route table with a route to the internet gateway
4. Deploy an EC2 instance inside of the created subnet
5. Associate a public IP and a security group that allows public ingress
6. Change the EC2 instance type to use a public available NGINX AMI
7. Destroy