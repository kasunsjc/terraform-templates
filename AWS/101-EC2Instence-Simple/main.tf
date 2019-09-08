/*
*Author - Kasun Rajapakse
*Subject - Azure Recovery Vault 
*Language - HCL 
! Last Modify Date - Sep 7 2019
! Disclaimer- LEGAL DISCLAIMER
This Sample Code is provided for the purpose of illustration only and is not
intended to be used in a production environment.  THIS SAMPLE CODE AND ANY
RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  We grant You a
nonexclusive, royalty-free right to use and modify the Sample Code and to
reproduce and distribute the object code form of the Sample Code, provided
that You agree: (i) to not use Our name, logo, or trademarks to market Your
software product in which the Sample Code is embedded; (ii) to include a valid
copyright notice on Your software product in which the Sample Code is embedded;
and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and
against any claims or lawsuits, including attorneys’ fees, that arise or result
from the use or distribution of the Sample Code. 
*/

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

