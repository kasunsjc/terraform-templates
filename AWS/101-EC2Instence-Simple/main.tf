#Use AWS Credential files for the authentication 
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/<userName>/.aws/creds" #AWS Credential File Name
  profile                 = "dev-account"
}

resource "aws_instance" "first_instence" {
  ami = "ami-0b898040803850657" #Amazon Linux VM --> Default VPC
  instance_type = "t2.micro"

  tags ={
      Name = "test-vm"
  }
}

