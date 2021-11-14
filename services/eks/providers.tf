provider "aws" {
  profile = "root"
  region = "${var.region}"
}

provider "http" {}