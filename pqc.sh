#!/bin/bash

set -eux -o pipefail

OPENSSL_CLI="$HOME/.local/openssl-3.6.0-dev-fips-debug-10bd6fa8ca/bin/openssl"

function print_usage {
    cat <<EOF
Usage: ${0} command

Commands
  * generate-keys-certs: Generate private keys and certificates used in this
    script.
  * start-dual-cert-server: Start TLS server with dual certificates ML-DSA
    and RSA.
  * start-mldsa-cert-server: Start TLS server with ML-DSA.
  * start-rsa-cert-server: Start TLS server with RSA.
  * connect-mldsa: Connect to the server with ML-DSA.
  * connect-mldsa-classic: Connect to the server with ML-DSA and classic key
    exchange.
  * connect-rsa: Connect to the server with RSA.
  * connect-rsa-classic: Connect to the server with RSA and classic key
    exchange.
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
    # RSA 2048 bits: Not supported as post-quantum cryptography.
    "${OPENSSL_CLI}" req \
        -x509 \
        -newkey rsa:2048 \
        -keyout localhost-rsa.key \
        -subj /CN=localhost \
        -addext subjectAltName=DNS:localhost \
        -nodes \
        -out localhost-rsa.crt
}

function start_server_with_dual_certificates {
    "${OPENSSL_CLI}" s_server \
        -cert localhost-mldsa.crt -key localhost-mldsa.key \
        -dcert localhost-rsa.crt -dkey localhost-rsa.key
}

function start_server_with_mldsa_certificate {
    "${OPENSSL_CLI}" s_server \
        -cert localhost-mldsa.crt -key localhost-mldsa.key
}

function start_server_with_rsa_certificate {
    "${OPENSSL_CLI}" s_server \
        -cert localhost-rsa.crt -key localhost-rsa.key
}

function connect_mldsa {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-mldsa.crt </dev/null
}

# Force the use of classic key exchange.
function connect_mldsa_classic {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-mldsa.crt \
        -groups 'X25519:secp256r1:X448:secp521r1:secp384r1' \
        </dev/null
}

function connect_rsa {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-rsa.crt \
        -sigalgs 'rsa_pss_pss_sha256:rsa_pss_rsae_sha256' </dev/null
}

# Force the use of classic key exchange.
function connect_rsa_classic {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-rsa.crt \
        -sigalgs 'rsa_pss_pss_sha256:rsa_pss_rsae_sha256' \
        -groups 'X25519:secp256r1:X448:secp521r1:secp384r1' \
        </dev/null
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
start-dual-cert-server)
    start_server_with_dual_certificates
    ;;
start-mldsa-cert-server)
    start_server_with_mldsa_certificate
    ;;
start-rsa-cert-server)
    start_server_with_rsa_certificate
    ;;
connect-mldsa)
    connect_mldsa
    ;;
connect-mldsa-classic)
    connect_mldsa_classic
    ;;
connect-rsa)
    connect_rsa
    ;;
connect-rsa-classic)
    connect_rsa_classic
    ;;
*)
    print_usage
    exit 2
esac

echo "OK"
