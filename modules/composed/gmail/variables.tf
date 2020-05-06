
# variable "site_verification" {
#   # default = "google-site-verification=t5vk..."
# }

variable "aws_region" {
  type = string
  default = "ap-southeast-1"
}

variable "domain" {
  type = string
}

variable "google_suite_cnames" {
  type    = set(string)
  default = ["mail"] # , "cal", "docs"
}
