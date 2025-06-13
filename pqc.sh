#!/bin/bash

set -eux -o pipefail

OPENSSL_CLI="$HOME/.local/openssl-3.6.0-dev-fips-debug-10bd6fa8ca/bin/openssl"

function print_usage {
    cat <<EOF
Usage: ${0} command

Commands
  * generate-keys-certs: Generate private keys and certificates used in this
    script.
  * start-dual-cert-server: An alias of
    start-dual-cert-mldsa-and-rsa-server-X25519MLKEM768.
  * start-dual-cert-mldsa-and-rsa-server-X25519MLKEM768: Start TLS server with
    dual certificates ML-DSA and RSA, and TLS group X25519MLKEM768.
  * start-dual-cert-mldsa-and-rsa-server-SecP256r1MLKEM768: Start TLS server
    with dual certificates ML-DSA and RSA, and TLS group SecP256r1MLKEM768.
  * start-dual-cert-mldsa-and-rsa-server-SecP384r1MLKEM1024: Start TLS server
    with dual certificates ML-DSA and RSA, and TLS group SecP384r1MLKEM1024.
  * start-dual-cert-mldsa-and-rsa-pss-server: Start TLS server with dual
    certificates ML-DSA and RSA-PSS.
  * start-mldsa-cert-server: Start TLS server with ML-DSA.
  * start-rsa-cert-server: Start TLS server with RSA.
  * connect-mldsa: An alias of connect-mldsa-25519MLKEM768.
  * connect-mldsa-25519MLKEM768: Connect to the server with ML-DSA, and TLS
    group X25519MLKEM768.
  * connect-mldsa-SecP256r1MLKEM768: Connect to the server with ML-DSA, and TLS
    group SecP256r1MLKEM768.
  * connect-mldsa-SecP384r1MLKEM1024: Connect to the server with ML-DSA, and TLS
    group SecP384r1MLKEM1024.
  * connect-mldsa-classic: Connect to the server with ML-DSA and classic key
    exchange.
  * connect-rsa: An alias of connect-rsa-X25519MLKEM768.
  * connect-rsa-X25519MLKEM768: Connect to the server with RSA, and TLS group
    X25519MLKEM768.
  * connect-rsa-SecP256r1MLKEM768: Connect to the server with RSA, and TLS group
    SecP256r1MLKEM768.
  * connect-rsa-SecP384r1MLKEM1024: Connect to the server with RSA, and TLS
    group SecP384r1MLKEM1024.
  * connect-rsa-classic: Connect to the server with RSA and classic key
    exchange.
  * connect-rsa-pss: Connect to the server with RSA-PSS.
EOF
}

function generate_keys_certs {
    # ML-DSA-65, supported as post-quantum cryptography.
    "${OPENSSL_CLI}" req \
        -x509 \
        -newkey mldsa65 \
        -keyout localhost-mldsa.key \
        -subj /CN=localhost \
        -addext subjectAltName=DNS:localhost \
        -nodes \
        -out localhost-mldsa.crt
    # RSA-PKCS#1v1.5 2048 bits: Not supported as post-quantum cryptography.
    "${OPENSSL_CLI}" req \
        -x509 \
        -newkey rsa:2048 \
        -keyout localhost-rsa.key \
        -subj /CN=localhost \
        -addext subjectAltName=DNS:localhost \
        -nodes \
        -out localhost-rsa.crt
    # RSA-PSS 2048 bits: Not supported as post-quantum cryptography.
    "${OPENSSL_CLI}" req \
        -x509 \
        -newkey rsa-pss:2048 \
        -keyout localhost-rsa-pss.key \
        -subj /CN=localhost \
        -addext subjectAltName=DNS:localhost \
        -nodes \
        -out localhost-rsa-pss.crt
}

function start_server_with_cert_mldsa_and_rsa_group_X25519MLKEM768 {
    "${OPENSSL_CLI}" s_server \
        -cert localhost-mldsa.crt -key localhost-mldsa.key \
        -dcert localhost-rsa.crt -dkey localhost-rsa.key
}

# The TLS group SecP256r1MLKEM768 is not enabled as a default.
function start_server_with_cert_mldsa_and_rsa_group_SecP256r1MLKEM768 {
    "${OPENSSL_CLI}" s_server \
        -cert localhost-mldsa.crt -key localhost-mldsa.key \
        -dcert localhost-rsa.crt -dkey localhost-rsa.key \
        -groups "SecP256r1MLKEM768"
}

# The TLS group SecP384r1MLKEM1024 is not enabled as a default.
function start_server_with_cert_mldsa_and_rsa_group_SecP384r1MLKEM1024 {
    "${OPENSSL_CLI}" s_server \
        -cert localhost-mldsa.crt -key localhost-mldsa.key \
        -dcert localhost-rsa.crt -dkey localhost-rsa.key \
        -groups "SecP384r1MLKEM1024"
}

function start_server_with_cert_mldsa_and_rsa_pss {
    "${OPENSSL_CLI}" s_server \
        -cert localhost-mldsa.crt -key localhost-mldsa.key \
        -dcert localhost-rsa-pss.crt -dkey localhost-rsa-pss.key
}

function start_server_with_cert_mldsa {
    "${OPENSSL_CLI}" s_server \
        -cert localhost-mldsa.crt -key localhost-mldsa.key
}

function start_server_with_cert_rsa {
    "${OPENSSL_CLI}" s_server \
        -cert localhost-rsa.crt -key localhost-rsa.key
}

function connect_mldsa_group_X25519MLKEM768 {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-mldsa.crt \
        </dev/null
}

# The TLS group SecP256r1MLKEM768 is not enabled as a default.
function connect_mldsa_group_SecP256r1MLKEM768 {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-mldsa.crt \
        -groups "SecP256r1MLKEM768" \
        </dev/null
}

# The TLS group SecP384r1MLKEM1024 is not enabled as a default.
function connect_mldsa_group_SecP384r1MLKEM1024 {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-mldsa.crt \
        -groups "SecP384r1MLKEM1024" \
        </dev/null
}

# Force the use of classic key exchange.
function connect_mldsa_group_classic {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-mldsa.crt \
        -groups 'X25519:secp256r1:X448:secp521r1:secp384r1' \
        </dev/null
}

function connect_rsa_group_X25519MLKEM768 {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-rsa.crt \
        -sigalgs 'rsa_pss_rsae_sha256' \
        </dev/null
}

function connect_rsa_group_SecP256r1MLKEM768 {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-rsa.crt \
        -sigalgs 'rsa_pss_rsae_sha256' \
        -groups "SecP256r1MLKEM768" \
        </dev/null
}

function connect_rsa_group_SecP384r1MLKEM1024 {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-rsa.crt \
        -sigalgs 'rsa_pss_rsae_sha256' \
        -groups "SecP384r1MLKEM1024" \
        </dev/null
}

# Force the use of classic key exchange.
function connect_rsa_group_classic {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-rsa.crt \
        -sigalgs 'rsa_pss_rsae_sha256' \
        -groups 'X25519:secp256r1:X448:secp521r1:secp384r1' \
        </dev/null
}

function connect_rsa_pss {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-rsa-pss.crt \
        -sigalgs 'rsa_pss_pss_sha256' </dev/null
}

if [ "${#}" -lt 1 ]; then
    print_usage
    exit 1
fi

cmd="${1}"
case "${cmd}" in
generate-keys-certs)
    generate_keys_certs
    ;;
start-dual-cert-mldsa-and-rsa-server-X25519MLKEM768 | start-dual-cert-server)
    start_server_with_cert_mldsa_and_rsa_group_X25519MLKEM768
    ;;
start-dual-cert-mldsa-and-rsa-server-SecP256r1MLKEM768)
    start_server_with_cert_mldsa_and_rsa_group_SecP256r1MLKEM768
    ;;
start-dual-cert-mldsa-and-rsa-server-SecP384r1MLKEM1024)
    start_server_with_cert_mldsa_and_rsa_group_SecP384r1MLKEM1024
    ;;
start-dual-cert-mldsa-and-rsa-pss-server)
    start_server_with_cert_mldsa_and_rsa_pss
    ;;
start-mldsa-cert-server)
    start_server_with_cert_mldsa
    ;;
start-rsa-cert-server)
    start_server_with_cert_rsa
    ;;
connect-mldsa-25519MLKEM768 | connect-mldsa)
    connect_mldsa_group_X25519MLKEM768
    ;;
connect-mldsa-SecP256r1MLKEM768)
    connect_mldsa_group_SecP256r1MLKEM768
    ;;
connect-mldsa-SecP384r1MLKEM1024)
    connect_mldsa_group_SecP384r1MLKEM1024
    ;;
connect-mldsa-classic)
    connect_mldsa_group_classic
    ;;
connect-rsa-X25519MLKEM768 | connect-rsa)
    connect_rsa_group_X25519MLKEM768
    ;;
connect-rsa-SecP256r1MLKEM768)
    connect_rsa_group_SecP256r1MLKEM768
    ;;
connect-rsa-SecP384r1MLKEM1024)
    connect_rsa_group_SecP384r1MLKEM1024
    ;;
connect-rsa-classic)
    connect_rsa_group_classic
    ;;
connect-rsa-pss)
    connect_rsa_pss
    ;;
*)
    print_usage
    exit 2
esac

echo "OK"
