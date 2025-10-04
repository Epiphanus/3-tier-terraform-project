provider "aws" {
  region = "us-west-1"
}

module "vpc" {
  source                    = "./vpc"
  tags                      = local.project_tags
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_block  = var.public_subnet_cidr_block
  availability_zone         = var.availability_zone
  private_subnet_cidr_block = var.private_subnet_cidr_block
  db_subnet_cidr_block      = var.db_subnet_cidr_block
}

module "alb" {
  source                           = "./alb"
  vpc_id                           = module.vpc.vpc_id
  apci_jupiter_public_subnet_az_1a = module.vpc.apci_jupiter_public_subnet_az_1a
  apci_jupiter_public_subnet_az_1c = module.vpc.apci_jupiter_public_subnet_az_1c
  tags                             = local.project_tags
}

module "auto-scaling" {
  source                           = "./auto-scaling"
  apci_jupiter_tg                  = module.alb.apci_jupiter_tg
  apci_jupiter_alb_sg              = module.alb.apci_jupiter_alb_sg
  vpc_id                           = module.vpc.vpc_id
  image_id                         = var.image_id
  instance_type                    = var.instance_type
  key_name                         = var.key_name
  apci_jupiter_public_subnet_az_1a = module.vpc.apci_jupiter_public_subnet_az_1a
  apci_jupiter_public_subnet_az_1c = module.vpc.apci_jupiter_public_subnet_az_1c
}

module "compute" {
  source                            = "./compute"
  key_name                          = var.key_name
  apci_jupiter_private_subnet_az_1a = module.vpc.apci_jupiter_private_subnet_az_1a
  apci_jupiter_private_subnet_az_1c = module.vpc.apci_jupiter_private_subnet_az_1c
  instance_type                     = var.instance_type
  vpc_id                            = module.vpc.vpc_id
  image_id                          = var.image_id
  apci_jupiter_public_subnet_az_1a  = module.vpc.apci_jupiter_public_subnet_az_1a
  tags                              = local.project_tags
}