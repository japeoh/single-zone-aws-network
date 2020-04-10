locals {
  zone_name              = var.with_internet_gateway ? "public" : "dmz"
  zone_default_nacl_cidr = var.with_internet_gateway ? local.all_ip_addresses : local.all_private_addresses

  zone_cidr_block         = length(var.zone_cidr_block) > 0 ? var.zone_cidr_block : var.vpc_cidr_block
  zone_ingress_cidr_block = length(var.zone_ingress_cidr_block) > 0 ? var.zone_ingress_cidr_block : local.zone_default_nacl_cidr
  zone_egress_cidr_block  = length(var.zone_egress_cidr_block) > 0 ? var.zone_egress_cidr_block : local.zone_default_nacl_cidr

  number_of_external_routes = var.with_internet_gateway ? var.number_of_availability_zones : 0

  all_ip_addresses      = "0.0.0.0/0"
  all_private_addresses = "10.0.0.0/8"
}

module meta {
  source = "github.com/japeoh/meta-tfmodule"

  name          = var.name
  environment   = var.environment
  organisation  = var.organisation
  domain_suffix = var.domain_suffix
  tags          = var.tags
}

module vpc {
  source = "github.com/japeoh/aws-vpc-tfmodule"

  role_arn                       = var.role_arn
  region                         = var.region
  name                           = module.meta.name_suffix
  domain                         = module.meta.domain
  tags                           = merge(var.tags, module.meta.tags)
  cidr_block                     = var.vpc_cidr_block
  with_ipv6_cidr_block           = var.with_ipv6_cidr_block
  with_dns_support               = true
  with_dns_hostnames             = true
  with_internet_gateway          = var.with_internet_gateway
  with_private_r53_zone          = var.with_private_r53_zone
  with_vpc_flow_log              = var.with_vpc_flow_log
  vpc_flow_log_traffic_type      = "ALL"
  vpc_flow_log_retention_in_days = 7
}

module zone {
  source = "github.com/japeoh/aws-zone-tfmodule"

  role_arn                     = var.role_arn
  region                       = var.region
  name                         = local.zone_name
  name_suffix                  = module.meta.name_suffix
  tags                         = merge(var.tags, module.meta.tags)
  vpc_id                       = module.vpc.vpc_id
  number_of_availability_zones = var.number_of_availability_zones
  cidr_block                   = local.zone_cidr_block
  ingress_cidr_block           = local.zone_ingress_cidr_block
  egress_cidr_block            = local.zone_egress_cidr_block
}
