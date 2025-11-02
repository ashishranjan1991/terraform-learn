variable "ami_id" {
    description = "inserting ami value"
    type = string
    default = "" 
}

variable "instance_type" {
  description = "this is instance type"
  type = string
  default = ""
}
variable "instance_class" {
  description = "this is rds instance"
  type = string
  default = ""
}