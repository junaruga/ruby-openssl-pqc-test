# ruby-openssl-pqc-test

This repository is to test [Ruby OpenSSL] in the [post-quantum cryptography][NIST Post Quantum Cryptography] cases. I referred to [this Red Hat blog about post-quantum cryptography in RHEL 10][Red Hat blog PQC RHEL 10] for details.

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

### Test with shell scripts

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

Then the TLS server prints the following lines.

```
$ ./pqc.sh start-dual-cert-server
...
-----BEGIN SSL SESSION PARAMETERS-----
MIGEAgEBAgIDBAQCEwIEIM/weUdw20CnhicSA2CWJDHseL43ROg7iuBCJ6otX9iQ
BDAJPnzunWRYVVjShMHuyk6upB4Djp8+CIZYSwyBnboIc1qXYJwlc8DeBUQcIyxQ
WT+hBgIEaDn976IEAgIcIKQGBAQBAAAArgcCBQCN8AF7swQCAhHs
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: id-ml-dsa-65:id-ml-dsa-87:id-ml-dsa-44:ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:ecdsa_brainpoolP256r1_sha256:ecdsa_brainpoolP384r1_sha384:ecdsa_brainpoolP512r1_sha512:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224:DSA+SHA224:DSA+SHA256:DSA+SHA384:DSA+SHA512
Shared Signature Algorithms: id-ml-dsa-65:id-ml-dsa-87:id-ml-dsa-44:ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:ecdsa_brainpoolP256r1_sha256:ecdsa_brainpoolP384r1_sha384:ecdsa_brainpoolP512r1_sha512:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224
Supported groups: X25519MLKEM768:x25519:secp256r1:x448:secp384r1:secp521r1:ffdhe2048:ffdhe3072
Shared groups: X25519MLKEM768:x25519:secp256r1:x448:secp384r1:secp521r1:ffdhe2048:ffdhe3072
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
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

Then the TLS server prints the following lines.

```
$ ./pqc.sh start-dual-cert-server
...
-----BEGIN SSL SESSION PARAMETERS-----
MIGEAgEBAgIDBAQCEwIEIN9R3YltDrfPLsX106/D8Vrb+0l+bu3L8OSsLWcyP23x
BDAzq4PiPXdcBMdN2vrua90zMMa+d6jPJdSnS4/pNRGuLK7tyOUtjkA5esQvLFhg
osahBgIEaDn+UKIEAgIcIKQGBAQBAAAArgcCBQCRXGN8swQCAhHs
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: rsa_pss_pss_sha256:RSA-PSS+SHA256
Shared Signature Algorithms: rsa_pss_pss_sha256:RSA-PSS+SHA256
Supported groups: X25519MLKEM768:x25519:secp256r1:x448:secp384r1:secp521r1:ffdhe2048:ffdhe3072
Shared groups: X25519MLKEM768:x25519:secp256r1:x448:secp384r1:secp521r1:ffdhe2048:ffdhe3072
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

### Test TLS dual certificates server implemented in Ruby.

Start TLS server with dual certificates ML-DSA and RSA.

Set the library path option (`-I`) to the Ruby OpenSSL.

```
$ ruby -I$/path/to/ruby/openssl/lib start-dual-cert-server.rb
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

### Test the clients implemented in Ruby.

Start TLS server with dual certificates ML-DSA and RSA.

```
$ ./pqc.sh start-dual-cert-server
...
ACCEPT
```

Connect to the server with ML-DSA.

```
$ ruby -I/path/to/ruby/openssl/lib connect.rb mldsa
SSL Version: TLSv1.3
Cert:
Cipher: ["TLS_AES_256_GCM_SHA384", "TLSv1.3", 256, 256]
```

Then the TLS server prints the following lines.

```
$ ./pqc.sh start-dual-cert-server
...
-----BEGIN SSL SESSION PARAMETERS-----
MIGEAgEBAgIDBAQCEwIEINWMzYxV5ua002d70t6D22otKh7vPZ2CK+TIXhiZ1ovI
BDCKIMLZCM5yfrgys96xVj3HHn3+pnxJsOtb2rVGI0BRqtZxZ89B2pSNwaLFjmBt
wcehBgIEaEGyb6IEAgIcIKQGBAQBAAAArgcCBQDudb1rswQCAhHs
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: id-ml-dsa-65:id-ml-dsa-87:id-ml-dsa-44:ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:ecdsa_brainpoolP256r1_sha256:ecdsa_brainpoolP384r1_sha384:ecdsa_brainpoolP512r1_sha512:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224:DSA+SHA224:DSA+SHA256:DSA+SHA384:DSA+SHA512
Shared Signature Algorithms: id-ml-dsa-65:id-ml-dsa-87:id-ml-dsa-44:ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:ecdsa_brainpoolP256r1_sha256:ecdsa_brainpoolP384r1_sha384:ecdsa_brainpoolP512r1_sha512:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224
Supported groups: X25519MLKEM768:x25519:secp256r1:x448:secp384r1:secp521r1:ffdhe2048:ffdhe3072
Shared groups: X25519MLKEM768:x25519:secp256r1:x448:secp384r1:secp521r1:ffdhe2048:ffdhe3072
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

Connect to the server with RSA.

```
$ ruby -I/path/to/ruby/openssl/lib connect.rb rsa
SSL Version: TLSv1.3
Cert:
Cipher: ["TLS_AES_256_GCM_SHA384", "TLSv1.3", 256, 256]
```

Then the TLS server prints the following lines.

```
$ ./pqc.sh start-dual-cert-server
...
-----BEGIN SSL SESSION PARAMETERS-----
MIGDAgEBAgIDBAQCEwIEIO0wXE2LOf0H9xkdMYJ2OjNIRMdbf5323lalBrv/RvG6
BDCW60J6wAjspmDGMYuhVV15O8rucQUT0LOPzT3OhLR/B9AfN419ABsqSsCz2APr
6ZahBgIEaEHjiqIEAgIcIKQGBAQBAAAArgYCBGi3NAKzBAICEew=
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: rsa_pss_pss_sha256:RSA-PSS+SHA256
Shared Signature Algorithms: rsa_pss_pss_sha256:RSA-PSS+SHA256
Supported groups: X25519MLKEM768:x25519:secp256r1:x448:secp384r1:secp521r1:ffdhe2048:ffdhe3072
Shared groups: X25519MLKEM768:x25519:secp256r1:x448:secp384r1:secp521r1:ffdhe2048:ffdhe3072
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

[Ruby OpenSSL]: https://github.com/ruby/openssl
[NIST Post Quantum Cryptography]: https://csrc.nist.gov/projects/post-quantum-cryptography
[Red Hat blog PQC RHEL 10]: https://www.redhat.com/en/blog/post-quantum-cryptography-red-hat-enterprise-linux-10
