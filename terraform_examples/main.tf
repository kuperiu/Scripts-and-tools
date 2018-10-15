#dynamic aws az scanning
module "ireland" {
  source = "./test"
  providers = {
    aws = "aws.ireland"
  }
}

module "frankfurt" {
  source = "./test"
  providers = {
    aws = "aws.frankfurt"
  }
}

#get the current intent ip dynamclly 
data "external" "whatismyip" {
 program = ["${path.module}/myip.sh"]
}

output "myip" {
  value = "${data.external.whatismyip.result["my_ip"]}"
}
