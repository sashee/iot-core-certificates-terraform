# iot-core-certificates-terraform

## Verify with CA

* Good:

```bash
openssl verify -CAfile <(terraform output -raw ca_pem) <(terraform output -raw signed_1_pem)
```

* Bad:

```bash
openssl verify -CAfile <(terraform output -raw ca_pem) <(terraform output -raw signed_2_pem)
```
