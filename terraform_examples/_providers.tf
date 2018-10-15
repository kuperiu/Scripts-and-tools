provider "aws" {
    region = "eu-west-1"
    alias = "ireland"
}

provider "aws" {
    region = "eu-central-1"
    alias = "frankfurt"
}

provider "external" {
  
}
