variable "subnet_id" {
  description = "ID da subnet pública (use uma existente no Academy)"
  type        = string
}

variable "security_group_id" {
  description = "Security Group com porta 3000 liberada"
  type        = string
}
