
resource "aws_instance" "projeto3" {
  ami           = "ami-01beb64058d271bc4"
  instance_type = "t2.micro"
  #private_key = "${file("${path.module}/projeto3.pem")}"
  key_name = "projeto3_ansible_xibo"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmHKvQHsinpelrRcsc+1HKmjcVTx4LONzy+iXYDNoJppW52AKMvQs+x/YCb5qvtpAOgbXHOlAT5dUFqyzogY1Ch7cGEsXyoLHdZgMIsn1itwHAe0s87CjKvRKgjzBlLYTa+5b/Ai+mM3zJCvEbDIcSqvGFJIQeJHNOwj33R+8Z8Du7Np+hfT7HWx89B72fthoV+UcGkEmBbHe5CyHKT9p2ydSRqRkTisVAJGnNN4BooNG7iKcBxvKfal3PCLpqwvNME5OHiHPfBIT0rfrGupfifSYSlwzTG+lyFHEeBsbcDJfawhNNMhFpaKekt0BJVGf0wixm0MTrRNgcjg5FaaeDQ== rsa-key-20181029"  
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
