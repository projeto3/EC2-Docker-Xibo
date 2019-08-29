#resource "aws_key_pair" "default" {
#  public_key = "${file("${var.key_path}")}"
#}
resource "aws_key_pair" "projeto-pipeline" {
  key_name = "projeto-pipeline"
  public_key = "tprojeto-pipeline.pub"
}
