provider "aws" {
  region                  = "us-west-1"
    shared_credentials_file ="~/.aws/credentials"

}


resource "aws_instance" "Udacity_T2" {
ami = "ami-09a3e40793c7092f5"
instance_type = "t2.micro"
count         = "4"
 key_name = "ec2_aws_learn"
   subnet_id     = "subnet-08463862319fcfe8d"
  tags = {
    Name = "Udacity T2"
  }
}

/*
resource "aws_instance" "Udacity_M4" {
ami = "ami-09a3e40793c7092f5"
instance_type = "m4.large"
count         = "2"
 key_name = "ec2_aws_learn"
   subnet_id     = "subnet-08463862319fcfe8d"
  tags = {
    Name = "Udacity_M4"
  }
}
*/
