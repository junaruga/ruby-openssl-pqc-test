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

#### TLS group: X25519MLKEM768

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
MIGDAgEBAgIDBAQCEwIEIISoZ3D6g8+nG9g+LtehCR6H8ciw/dL0VHae2FAOM+PY
BDAuQGfccMj1nwRkSF5M+UsXkv0/v06J23cxn6zqTDfwjE7i55N1uS1fNY28E7XY
rVuhBgIEaEL1t6IEAgIcIKQGBAQBAAAArgYCBFCjnzGzBAICEew=
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: RSA-PSS+SHA256
Shared Signature Algorithms: RSA-PSS+SHA256
Supported groups: X25519MLKEM768:x25519:secp256r1:x448:secp384r1:secp521r1:ffdhe2048:ffdhe3072
Shared groups: X25519MLKEM768:x25519:secp256r1:x448:secp384r1:secp521r1:ffdhe2048:ffdhe3072
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

#### TLS group: SecP256r1MLKEM768

Start TLS server with dual certificates ML-DSA and RSA, and TLS group SecP256r1MLKEM768.

```
$ ./pqc.sh start-dual-cert-mldsa-and-rsa-server-SecP256r1MLKEM768
...
ACCEPT
```

Connect to the server with ML-DSA, and TLS group SecP256r1MLKEM768.

```
$ ./pqc.sh connect-mldsa-SecP256r1MLKEM768
...
Peer signature type: mldsa65
Negotiated TLS1.3 group: SecP256r1MLKEM768
...
OK
```

Then the TLS server prints the following lines.

```
$ ./pqc.sh start-dual-cert-mldsa-and-rsa-server-SecP256r1MLKEM768
...
-----BEGIN SSL SESSION PARAMETERS-----
MIGDAgEBAgIDBAQCEwIEIMLNysGUUN0NUtvgun7D1zFSoKW+VjBTHKiCmzEmOT5i
BDDnJflpC6Tp7l5M57ErMSCmIlaBlf0JatfyGFgk8e0jujMOLmzxEQUHVEM01MoW
obOhBgIEaEMVbKIEAgIcIKQGBAQBAAAArgYCBFs1HLuzBAICEes=
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: id-ml-dsa-65:id-ml-dsa-87:id-ml-dsa-44:ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:ecdsa_brainpoolP256r1_sha256:ecdsa_brainpoolP384r1_sha384:ecdsa_brainpoolP512r1_sha512:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224:DSA+SHA224:DSA+SHA256:DSA+SHA384:DSA+SHA512
Shared Signature Algorithms: id-ml-dsa-65:id-ml-dsa-87:id-ml-dsa-44:ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:ecdsa_brainpoolP256r1_sha256:ecdsa_brainpoolP384r1_sha384:ecdsa_brainpoolP512r1_sha512:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224
Supported groups: SecP256r1MLKEM768
Shared groups: SecP256r1MLKEM768
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

Connect to the server with RSA, and TLS group SecP256r1MLKEM768.

```
$ ./pqc.sh connect-rsa-SecP256r1MLKEM768
...
Peer signing digest: SHA256
Peer signature type: rsa_pss_rsae_sha256
Negotiated TLS1.3 group: SecP256r1MLKEM768
...
OK
```

Then the TLS server prints the following lines.

```
$ ./pqc.sh start-dual-cert-mldsa-and-rsa-server-SecP256r1MLKEM768
...
-----BEGIN SSL SESSION PARAMETERS-----
MIGEAgEBAgIDBAQCEwIEIACyoT3m42MWPgeNYVYPPJw92XBc+CgsjBOPE7uGw4bU
BDAnPDXLKzC1iTPKtE1Roq5CtoYF9skMZuudeb3sE4KhuX6oduubSF/g2jAbXWRs
rTahBgIEaEMWLqIEAgIcIKQGBAQBAAAArgcCBQD6Z3P4swQCAhHr
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: RSA-PSS+SHA256
Shared Signature Algorithms: RSA-PSS+SHA256
Supported groups: SecP256r1MLKEM768
Shared groups: SecP256r1MLKEM768
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

#### TLS group: SecP384r1MLKEM1024

Start TLS server with dual certificates ML-DSA and RSA, and TLS group SecP384r1MLKEM1024.

```
$ ./pqc.sh start-dual-cert-mldsa-and-rsa-server-SecP384r1MLKEM1024
...
ACCEPT
```

Connect to the server with ML-DSA, and TLS group SecP384r1MLKEM1024.

```
$ ./pqc.sh connect-mldsa-SecP384r1MLKEM1024
...
Peer signature type: mldsa65
Negotiated TLS1.3 group: SecP384r1MLKEM1024
...
OK
```

Then the TLS server prints the following lines.

```
$ ./pqc.sh start-dual-cert-mldsa-and-rsa-server-SecP384r1MLKEM1024
...
-----BEGIN SSL SESSION PARAMETERS-----
MIGEAgEBAgIDBAQCEwIEID2RuZQrUbuagrxPXUA/SAfP+z0ZXb5yDt7gPtzrP+wV
BDBwoLJaLP9Da/2+pHegNB59O4bsPJo59WRYL0yFOiW0rVB+xJ8Y2Bx1EPQGS02Z
1QqhBgIEaEw71aIEAgIcIKQGBAQBAAAArgcCBQCapricswQCAhHt
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: id-ml-dsa-65:id-ml-dsa-87:id-ml-dsa-44:ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:ecdsa_brainpoolP256r1_sha256:ecdsa_brainpoolP384r1_sha384:ecdsa_brainpoolP512r1_sha512:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224:DSA+SHA224:DSA+SHA256:DSA+SHA384:DSA+SHA512
Shared Signature Algorithms: id-ml-dsa-65:id-ml-dsa-87:id-ml-dsa-44:ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:ecdsa_brainpoolP256r1_sha256:ecdsa_brainpoolP384r1_sha384:ecdsa_brainpoolP512r1_sha512:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224
Supported groups: SecP384r1MLKEM1024
Shared groups: SecP384r1MLKEM1024
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

Connect to the server with RSA, and TLS group SecP384r1MLKEM1024.

```
$ ./pqc.sh connect-rsa-SecP384r1MLKEM1024
...
Peer signing digest: SHA256
Peer signature type: rsa_pss_rsae_sha256
Negotiated TLS1.3 group: SecP384r1MLKEM1024
...
OK
```

Then the TLS server prints the following lines.

```
$ ./pqc.sh start-dual-cert-mldsa-and-rsa-server-SecP384r1MLKEM1024
...
-----BEGIN SSL SESSION PARAMETERS-----
MIGDAgEBAgIDBAQCEwIEIEESnvd5+bDPMtQ3Ki5DA/Mh0tSOzTpLTqXIxnrxBUuB
BDBwVa1iitpLml9986E/2goIf4Fd0/39FlnUCj4LF9sxf9YO7AATrCqnwsj96xvk
4IuhBgIEaEw8vqIEAgIcIKQGBAQBAAAArgYCBDixsI6zBAICEe0=
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: RSA-PSS+SHA256
Shared Signature Algorithms: RSA-PSS+SHA256
Supported groups: SecP384r1MLKEM1024
Shared groups: SecP384r1MLKEM1024
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

### Test TLS dual certificates server implemented in Ruby.

#### TLS group: X25519MLKEM768

Start TLS server with dual certificates ML-DSA and RSA.

Set the library path option (`-I`) to the Ruby OpenSSL.

```
$ ruby -I/path/to/ruby/openssl/lib start_dual_cert_server.rb
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

#### TLS group: SecP256r1MLKEM768

Start TLS server with dual certificates ML-DSA and RSA.

```
$ ruby -I/path/to/ruby/openssl/lib start_dual_cert_server.rb SecP256r1MLKEM768
```

Connect to the server with ML-DSA.

```
$ ./pqc.sh connect-mldsa-SecP256r1MLKEM768
...
Peer signature type: mldsa65
Negotiated TLS1.3 group: SecP256r1MLKEM768
...
OK
```

Connect to the server with RSA.

```
$ ./pqc.sh connect-rsa-SecP256r1MLKEM768
...
Peer signing digest: SHA256
Peer signature type: rsa_pss_rsae_sha256
Negotiated TLS1.3 group: SecP256r1MLKEM768
...
OK
```

#### TLS group: SecP384r1MLKEM1024

Start TLS server with dual certificates ML-DSA and RSA.

```
$ ruby -I/path/to/ruby/openssl/lib start_dual_cert_server.rb SecP384r1MLKEM1024
```

Connect to the server with ML-DSA.

```
$ ./pqc.sh connect-mldsa-SecP384r1MLKEM1024
...
Peer signature type: mldsa65
Negotiated TLS1.3 group: SecP384r1MLKEM1024
...
OK
```

Connect to the server with RSA.

```
$ ./pqc.sh connect-rsa-SecP384r1MLKEM1024
...
Peer signing digest: SHA256
Peer signature type: rsa_pss_rsae_sha256
Negotiated TLS1.3 group: SecP384r1MLKEM1024
...
OK
```

### Test the clients implemented in Ruby.

#### TLS group: X25519MLKEM768

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
MIGCAgEBAgIDBAQCEwIEIBhh/5eUoEMq/tw5aQCHHIkV9pKjtf4i6UTGDpTGdoSm
BDBdAX5YcHSCJdRuf+FqjZRrEYGxdNiWoU0I0VmoDGuCc30QUot38PiRotDp2seb
MRKhBgIEaEL2haIEAgIcIKQGBAQBAAAArgYCBCEs/rmzAwIBHQ==
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA
Signature Algorithms: ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224
Shared Signature Algorithms: ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224
Supported groups: x25519:secp256r1:x448:secp521r1:secp384r1:ffdhe2048:ffdhe3072:ffdhe4096:ffdhe6144:ffdhe8192
Shared groups: x25519:secp256r1:x448:secp521r1:secp384r1:ffdhe2048:ffdhe3072
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
MIGDAgEBAgIDBAQCEwIEICMFJYjarj+UBcxBt9YjGZ1AxI3bSgEl5CsEIylOt5w1
BDCJICKR3lZh0itfaMgUXllZPYzCVOitc8lyfJ5tx++lcnnF8rgqKcg//aK+OoND
Vh+hBgIEaEL246IEAgIcIKQGBAQBAAAArgYCBH2c/WCzBAICEew=
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: RSA-PSS+SHA256
Shared Signature Algorithms: RSA-PSS+SHA256
Supported groups: X25519MLKEM768:x25519:secp256r1:x448:secp384r1:secp521r1:ffdhe2048:ffdhe3072
Shared groups: X25519MLKEM768:x25519:secp256r1:x448:secp384r1:secp521r1:ffdhe2048:ffdhe3072
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

#### TLS group: SecP256r1MLKEM768

Start TLS server with dual certificates ML-DSA and RSA.

```
$ ./pqc.sh start-dual-cert-mldsa-and-rsa-server-SecP256r1MLKEM768
...
ACCEPT
```

Connect to the server with ML-DSA.

```
$ ruby -I/path/to/ruby/openssl/lib connect.rb mldsa SecP256r1MLKEM768
SSL Version: TLSv1.3
Cert:
Cipher: ["TLS_AES_256_GCM_SHA384", "TLSv1.3", 256, 256]
```

Then the TLS server prints the following lines.

```
$ ./pqc.sh start-dual-cert-mldsa-and-rsa-server-SecP256r1MLKEM768
...
-----BEGIN SSL SESSION PARAMETERS-----
MIGEAgEBAgIDBAQCEwIEIIBE94AiqaFxk1nEivsGkrPbqMVABZ5VHEn8ZYkhTv2J
BDDuFiJ9u1HpA3b/74VTu+5jFZBNSoL9fA7NWjoHeGgL0BezTqhQK+mE2a+kxEeE
YC+hBgIEaEwmeqIEAgIcIKQGBAQBAAAArgcCBQCPvV4uswQCAhHr
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: id-ml-dsa-65:id-ml-dsa-87:id-ml-dsa-44:ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:ecdsa_brainpoolP256r1_sha256:ecdsa_brainpoolP384r1_sha384:ecdsa_brainpoolP512r1_sha512:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224:DSA+SHA224:DSA+SHA256:DSA+SHA384:DSA+SHA512
Shared Signature Algorithms: id-ml-dsa-65:id-ml-dsa-87:id-ml-dsa-44:ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:ecdsa_brainpoolP256r1_sha256:ecdsa_brainpoolP384r1_sha384:ecdsa_brainpoolP512r1_sha512:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224
Supported groups: SecP256r1MLKEM768
Shared groups: SecP256r1MLKEM768
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

Connect to the server with RSA.

```
$ ruby -I/path/to/ruby/openssl/lib connect.rb rsa SecP256r1MLKEM768
SSL Version: TLSv1.3
Cert:
Cipher: ["TLS_AES_256_GCM_SHA384", "TLSv1.3", 256, 256]
```

Then the TLS server prints the following lines.

```
-----BEGIN SSL SESSION PARAMETERS-----
MIGEAgEBAgIDBAQCEwIEINr27R++pC6rrnBONsTDl9UxOIRpLm3VIbmC/y2v20EK
BDC1FEdgKZxR7uzFLEwHUNzR3FgEZ8iG0vDOBCNqOt4+BCfZlNS9tTRNkPDWxv27
zOyhBgIEaEwnAaIEAgIcIKQGBAQBAAAArgcCBQDaDO1AswQCAhHr
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: RSA-PSS+SHA256
Shared Signature Algorithms: RSA-PSS+SHA256
Supported groups: SecP256r1MLKEM768
Shared groups: SecP256r1MLKEM768
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

#### TLS group: SecP384r1MLKEM1024

Start TLS server with dual certificates ML-DSA and RSA.

```
$ ./pqc.sh start-dual-cert-mldsa-and-rsa-server-SecP384r1MLKEM1024
...
ACCEPT
```

Connect to the server with ML-DSA.

```
$ ruby -I/path/to/ruby/openssl/lib connect.rb mldsa SecP384r1MLKEM1024
SSL Version: TLSv1.3
Cert:
Cipher: ["TLS_AES_256_GCM_SHA384", "TLSv1.3", 256, 256]
```

Then the TLS server prints the following lines.

```
$ ./pqc.sh start-dual-cert-mldsa-and-rsa-server-SecP384r1MLKEM1024
...
-----BEGIN SSL SESSION PARAMETERS-----
MIGEAgEBAgIDBAQCEwIEIF7TtLdZGuHqGJa0n8gCIpG/PJh4m3oWdfVMaCAjOQB2
BDAhQcgpdXnTH9JxjS4Cd59ZZH71+fmJCoXlvYVCp4ORKPHFMp3hKOkjsBwoZ6Po
xwyhBgIEaExA6qIEAgIcIKQGBAQBAAAArgcCBQD2eC3mswQCAhHt
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: id-ml-dsa-65:id-ml-dsa-87:id-ml-dsa-44:ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:ecdsa_brainpoolP256r1_sha256:ecdsa_brainpoolP384r1_sha384:ecdsa_brainpoolP512r1_sha512:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224:DSA+SHA224:DSA+SHA256:DSA+SHA384:DSA+SHA512
Shared Signature Algorithms: id-ml-dsa-65:id-ml-dsa-87:id-ml-dsa-44:ECDSA+SHA256:ECDSA+SHA384:ECDSA+SHA512:ed25519:ed448:ecdsa_brainpoolP256r1_sha256:ecdsa_brainpoolP384r1_sha384:ecdsa_brainpoolP512r1_sha512:rsa_pss_pss_sha256:rsa_pss_pss_sha384:rsa_pss_pss_sha512:RSA-PSS+SHA256:RSA-PSS+SHA384:RSA-PSS+SHA512:RSA+SHA256:RSA+SHA384:RSA+SHA512:ECDSA+SHA224:RSA+SHA224
Supported groups: SecP384r1MLKEM1024
Shared groups: SecP384r1MLKEM1024
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

Connect to the server with RSA.

```
$ ruby -I/path/to/ruby/openssl/lib connect.rb rsa SecP384r1MLKEM1024
SSL Version: TLSv1.3
Cert:
Cipher: ["TLS_AES_256_GCM_SHA384", "TLSv1.3", 256, 256]
```

Then the TLS server prints the following lines.

```
$ ./pqc.sh start-dual-cert-mldsa-and-rsa-server-SecP384r1MLKEM1024
...
-----BEGIN SSL SESSION PARAMETERS-----
MIGDAgEBAgIDBAQCEwIEIN+VbOqQtAcbKOrRjOAElq9B4yXf/RQYHIF8poOsStY+
BDDSgSnXQyXxpvqODoP7Xwil8FsS/oxp5uttu7aS9XU7EnRvXe49yoPpseC3kOCO
b+ShBgIEaExBIqIEAgIcIKQGBAQBAAAArgYCBCa9a56zBAICEe0=
-----END SSL SESSION PARAMETERS-----
Shared ciphers:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA
Signature Algorithms: RSA-PSS+SHA256
Shared Signature Algorithms: RSA-PSS+SHA256
Supported groups: SecP384r1MLKEM1024
Shared groups: SecP384r1MLKEM1024
CIPHER is TLS_AES_256_GCM_SHA384
This TLS version forbids renegotiation.
DONE
shutting down SSL
CONNECTION CLOSED
```

[Ruby OpenSSL]: https://github.com/ruby/openssl
[NIST Post Quantum Cryptography]: https://csrc.nist.gov/projects/post-quantum-cryptography
[Red Hat blog PQC RHEL 10]: https://www.redhat.com/en/blog/post-quantum-cryptography-red-hat-enterprise-linux-10
