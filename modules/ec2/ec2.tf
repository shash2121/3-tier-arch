resource "aws_instance" "bastion" {
  count = var.ec2_num
  instance_type = var.instance_type
  ami = var.ami_id
  vpc_security_group_ids = [var.sg_id]
  key_name = var.key
  associate_public_ip_address = true
#  user_data = "${data.template_file.jenkins.rendered}"
  subnet_id = "${element(var.subnet_id,0)}"
    tags = {
    Name = "${var.ENV}-${var.name}-${count.index + 1}"
  }
}