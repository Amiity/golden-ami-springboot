packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

source "amazon-ebs" "springboot_base" {
  region        = "us-east-1"
  instance_type = "t2.micro"
  source_ami    = "ami-04681163a08179f28"
  ssh_username  = "ec2-user"
  ami_name      = "springboot-base-ami-{{timestamp}}"
  subnet_id     = "subnet-07aaae477c128d865"
  associate_public_ip_address = true


  tags = {
    Name        = "SpringBoot-Base-AMI"
    Environment = "Development"
    CreatedBy   = "Packer"
  }
}

build {
  sources = ["source.amazon-ebs.springboot_base"]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y java-17-amazon-corretto-devel",  # Install Amazon Corretto OpenJDK 17
      "java -version",  # Verify Java installation
      "sudo yum install -y unzip aws-cli",  # Install AWS CLI & Unzip
      "sudo mkdir -p /opt/springboot-app",  # Create application directory
      "sudo chmod -R 777 /opt/springboot-app",  # Give permissions
      "echo 'Spring Boot AMI setup complete!'"
    ]
  }
}