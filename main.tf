module "ec2_intance_v1" {
  source        = "./modules/ec2"
  project_name  = "Roweb"
  instance_type = "t3.micro"
  ami           = "ubuntu"
  volumen_size  = 10
  user_data     = templatefile("${path.module}/scripts/agent_ssm.sh", { web_app = "My Web App" })

}

module "ec2_instance" {
  source        = "./modules/ec2_instance"
  name          = "instance_module_external"
  instance_type = "t3.micro"
  subnet_id     = "subnet-07b4d4cd775588a4b"
  ami           = "ami-0d97d7f07b25dd693"
}
