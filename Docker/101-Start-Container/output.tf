output "ip_address" {
  value = "${docker_container.container.ip_address}"
  description = "IP address of the container"
}

#Output name of the Container
output "container_name" {
  value = "${docker_container.container.name}"
    description = "IP address of the container"
}
