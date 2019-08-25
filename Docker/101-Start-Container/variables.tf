variable "container_name" {
  default = "nginx"
}
variable "int_port" {
  default = "8080"
}
variable "ext_port" {
  default = "80"
}
variable "image_name" {
  description = "Image name use for the container"
  default = "nginx:latest"
}
