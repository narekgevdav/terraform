# Create the Jenkins master instance
resource "aws_instance" "jenkins_master" {
  ami           = var.ami_id
  instance_type = "t2.micro"     # Choose an appropriate instance type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.key-pair
  security_groups = [aws_security_group.jenkins-sec-group.id]

  tags = {
    Name = "Jenkins Master"
  }

  user_data = <<-EOF
    #!/bin/bash
    # Install Jenkins on the master instance
    sudo apt update
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian/jenkins.io-2023.key
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install fontconfig openjdk-17-jre -y
    sudo apt-get install jenkins -y
    sudo apt-get install awscli -y
    sudo apt-get install docker.io -y
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    EOF
}

## Create the Jenkins slave instance
#resource "aws_instance" "jenkins_slave" {
#  ami           = var.ami_id
#  instance_type = "t2.micro"     # Choose an appropriate instance type
##  subnet_id     = aws_subnet.private_subnet.id
#  key_name      = var.key-pair
#
#  tags = {
#    Name = "Jenkins Slave"
#  }
#
#  user_data = <<-EOF
#    #!/bin/bash
#    # Install Jenkins slave dependencies
#    # Replace with the appropriate commands to install dependencies
#
#    # Connect to the Jenkins master
#    java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s ${aws_instance.jenkins_master.public_ip}:8080/ -webSocket connect-node jenkins-slave secret-label
#    EOF
#
#  # Add a dependency on the Jenkins master to ensure the slave is launched after the master
#  depends_on = [aws_instance.jenkins_master]
#}


output "jenkins_master_url" {
  value = "http://${aws_instance.jenkins_master.public_ip}:8080/"
}

# Output the public IP addresses of the Jenkins master and slave
output "jenkins_master_ip" {
  value = aws_instance.jenkins_master.public_ip
}

