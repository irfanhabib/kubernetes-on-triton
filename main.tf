provider "triton" {
  account = "${var.account}"
  key_material  = "${file("${var.key_file}")}"
  key_id = "${var.key_hash}"
  url = "${var.endpoint_url}"
  insecure_skip_tls_verify = "${var.skip_tls_verify}"
}

resource "triton_machine" "kubernetes" {
  name                 = "kubernetes-test"
  package              = "${var.package}"
  image                = "${var.image}"
  firewall_enabled     = true
  user_script = "${file("init.sh")}"
  tags = {
    purpose = "testing kubernetes deployment"
  }
}

resource "triton_firewall_rule" "ssh" {
  rule    = "FROM any TO all vms ALLOW tcp PORT 22"
  enabled = true
}