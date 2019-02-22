# How to config vaiable should look like
#
# variable "configs" {
#   default = [
#       {
#           name = "secret"
#           text = "CiQAD83nzTBdHSHLlv2DQJpgLIjivzlDwScM0Skbi44n9AZa6HgSLQCxXumMkeoxPF0UC2HteCb7o9fH2g7W8PxpPnctuNk6cyzkyvbncWrIiY9bIA=="
#           encrypted = true
#       },
#       {
#           name = "some_key"
#           text = "1234"
#           encrypted = false
#       }
#   ]
# }

variable "crypto_key" {}

variable "parent" {}
variable "configs" {
  type = "list"
}

variable "default_text" {
  default = "CiQAD83nzTBdHSHLlv2DQJpgLIjivzlDwScM0Skbi44n9AZa6HgSLQCxXumMkeoxPF0UC2HteCb7o9fH2g7W8PxpPnctuNk6cyzkyvbncWrIiY9bIA=="
}

data "google_kms_secret" "main" {
  count = "${length(var.configs)}"
  crypto_key = "${var.crypto_key}"
  ciphertext = "${lookup(var.configs[count.index], "encrypted")  ? lookup(var.configs[count.index], "text") : var.default_text }"
}

locals {
    plaintext = "${data.google_kms_secret.main.*.plaintext}"
}
resource "google_runtimeconfig_variable" "main" {
    count = "${length(var.configs)}"
    parent = "${var.parent}"
    name = "${lookup(var.configs[count.index], "name")}"
    text = "${lookup(var.configs[count.index], "encrypted")  ? "${element(local.plaintext, count.index)}" : "${lookup(var.configs[count.index], "text")}" }"
}
