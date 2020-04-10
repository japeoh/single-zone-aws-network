variable role_arn {}

variable region {}

variable name {}

variable environment {}

variable organisation {}

variable domain_suffix {
  default = "internal"
}
variable tags {
  type    = map(string)
  default = {}
}

variable vpc_cidr_block {}

variable with_ipv6_cidr_block {
  type    = bool
  default = false
}

variable with_internet_gateway {
  type    = bool
  default = false
}
variable with_private_r53_zone {
  type    = bool
  default = false
}

variable with_vpc_flow_log {
  type    = bool
  default = true
}

variable number_of_availability_zones {
  type    = number
  default = 2
}

variable zone_cidr_block {
  default = ""
}

variable zone_ingress_cidr_block {
  default = ""
}
variable zone_egress_cidr_block {
  default = ""
}

output vpc_id {
  value = module.vpc.vpc_id
}

output internet_gateway_id {
  value = module.vpc.internet_gateway_id
}

output zone_subnet_ids {
  value = module.zone.subnet_ids
}

output zone_route_table_ids {
  value = module.zone.route_table_ids
}

output zone_network_acl_id {
  value = module.zone.network_acl_id
}

provider aws {
  version = "~> 2.53"
  region  = var.region

  assume_role {
    role_arn = var.role_arn
  }
}
