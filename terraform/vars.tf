resource "aws_key_pair" "projeto3_ansible_xibo" {
   # key_name = "projeto3_ansible_xibo"
    public_key = "${file("${path.module}/keys/id_rsa.pub")}"
}
