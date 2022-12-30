resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  validity_period_hours = 240

  allowed_uses = [
    "cert_signing",
  ]

  is_ca_certificate = true

  subject {
    organization = "CA test signer"
  }
}

resource "tls_private_key" "signed_1" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "signed_1" {
  private_key_pem = tls_private_key.signed_1.private_key_pem

  subject {
    organization = "CA test"
  }
}

resource "tls_locally_signed_cert" "signed_1" {
  cert_request_pem   = tls_cert_request.signed_1.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 240

  allowed_uses = [
  ]
}

resource "aws_iot_certificate" "ca_cert_1" {
  certificate_pem = trimspace(tls_locally_signed_cert.signed_1.cert_pem)
  active          = true
}

output "ca_pem" {
  value = tls_self_signed_cert.ca.cert_pem
}

output "signed_1_pem" {
  value = tls_locally_signed_cert.signed_1.cert_pem
}

