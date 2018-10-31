
resource "aws_instance" "projeto3" {
  ami           = "ami-01beb64058d271bc4"
  instance_type = "t2.micro"
  #private_key = "${file("${path.module}/projeto3.pem")}"
   key_name = "projeto3_ansible_xibo"
  #key_name = "${var.private_key_path)}"
  #key_name = "${aws_key_pair.mykeypair.key_name}"
  subnet_id     = "${aws_subnet.main-public-1.id}"
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
  associate_public_ip_address	= "true"
  #aws_security_group = "sg-0b70b9d3a1ae3add6"
  
  user_data = "${file("${path.module}/user_data.sh")}"
tags {
        Name = "DEV Teste Infraesturura Agil"
        Projeto = "Infraestrutura como codigo"
        Curso = "Redes de Computadores"
        Materia = "Projeto Integrador 3"
        Gerente_do_Projeto = "Professor Pablo Menezes"
    }
}
output "aws_ip" {
    value = "${aws_instance.projeto3.public_ip}"
}

output "aws_dns" {
    value = "${aws_instance.projeto3.public_dns}"
}
