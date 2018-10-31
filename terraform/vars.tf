resource "aws_key_pair" "test_keypair" {
    key_name = "test_keypair"
    public_key = "${file("${path.module}/keys/id_rsa.pub")}"
}
