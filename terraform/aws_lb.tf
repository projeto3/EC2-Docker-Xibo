resource "aws_elb" "lb" {
    name_prefix = "lb"
    subnets = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-1.id}"]
    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:80/"
        interval = 30
    }
    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
    cross_zone_load_balancing = true
    instances = ["${aws_instance.projeto3.id}", "${aws_instance.projeto3_2.id}"]
    security_groups = ["${aws_security_group.allow-ssh.id}"]
}
