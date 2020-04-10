resource aws_route external {
  count = local.number_of_external_routes

  route_table_id = module.zone.route_table_ids[count.index]
  gateway_id     = module.vpc.internet_gateway_id

  destination_cidr_block = local.all_ip_addresses
}
