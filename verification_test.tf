resource "tls_private_key" "ca_2" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca_2" {
  private_key_pem = tls_private_key.ca_2.private_key_pem

  validity_period_hours = 240

  allowed_uses = [
    "cert_signing",
  ]

  is_ca_certificate = true

  subject {
    organization = "CA test signer"
  }
}

resource "tls_private_key" "signed_2" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "signed_2" {
  private_key_pem = tls_private_key.signed_2.private_key_pem

  subject {
    organization = "CA test"
  }
}

resource "tls_locally_signed_cert" "signed_2" {
  cert_request_pem   = tls_cert_request.signed_2.cert_request_pem
  ca_private_key_pem = tls_private_key.ca_2.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_2.cert_pem

  validity_period_hours = 240

  allowed_uses = [
  ]
}

output "signed_2_pem" {
  value = tls_locally_signed_cert.signed_2.cert_pem
}

