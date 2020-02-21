variable "name" {
  description = "Name"
}

variable "namespace" {
  description = "`swt`. This will be used to scope the name"
  default     = "swt"
}

variable "stage" {
  description = "Stage / Environment (e.g. `stage`, `prod`)"
  default     = "stage"
}

variable "aws_region" {
  type = string
  default = "ap-southeast-1"
}

variable "dns_zone" {
  description = "parent dns zone"
  default     = "example.com"
}

variable "urls" {
  type = list(string)
}

variable "price_class" {
  description = "Which price_class to enable in CloudFront."
  default     = "PriceClass_200" # 200 covers everything except Australia / South America (100 only covers US and EU, All covers all)
}
