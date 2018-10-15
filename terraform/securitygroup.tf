resource "aws_security_group" "allow-ssh" {
  name = "allow-ssh"
  vpc_id = "${aws_vpc.main.id}"
  #vpc_id      = "vpc-c84f9cb0"
  description = "security group that allows ssh and all egress traffic"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 
   ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  
tags {
        Name = "DEV Teste Infraesturura Agil"
        Projeto = "Infraestrutura como codigo"
        Curso = "Redes de Computadores"
        Materia = "Projeto Integrador 3"
        Gerente_do_Projeto = "Professor Pablo Menezes"
    }
}
