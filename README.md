# ruby-openssl-pqc-test

This repository is to test [Ruby OpenSSL] with post-quantum cryptography related to [this blog][Red Hat blog PQC].

[Ruby OpenSSL]: https://github.com/ruby/openssl
[Red Hat blog PQC]: https://www.redhat.com/en/blog/post-quantum-cryptography-red-hat-enterprise-linux-10

## Usage

Edit the following line to set the path to the `openssl` command. I tested with the upstream OpenSSL development version 3.6 (openssl/openssl@10bd6fa8ca93b4cf53f005f110c827ed923c89a4). Maybe you need to OpenSSL version 3.5 or later versions.

```
$ grep ^OPENSSL_CLI pqc.sh
OPENSSL_CLI="/path/to/bin/openssl"
```

Generate private keys and certificates used in this test.

```
$ ./pqc.sh generate-keys-certs
```

Start TLS server with dual certificates ML-DSA and RSA.

```
$ ./pqc.sh start-dual-cert-server
...
ACCEPT
```

Connect to the server with ML-DSA.

```
$ ./pqc.sh connect-mldsa
...
Peer signature type: mldsa65
Negotiated TLS1.3 group: X25519MLKEM768
...
OK
```

Connect to the server with RSA.

```
$ ./pqc.sh connect-rsa
...
Peer signing digest: SHA256
Peer signature type: rsa_pss_rsae_sha256
Negotiated TLS1.3 group: X25519MLKEM768
...
OK
```
