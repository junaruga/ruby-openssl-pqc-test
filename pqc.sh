#!/bin/bash

set -eux -o pipefail

OPENSSL_CLI="$HOME/.local/openssl-3.6.0-dev-fips-debug-10bd6fa8ca/bin/openssl"

function usage {
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
  * connect-rsa: Connect to the server with RSA.
EOF
}

function generate-keys-certs {
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

function start-server-with-dual-certificates {
    "${OPENSSL_CLI}" s_server \
        -cert localhost-mldsa.crt -key localhost-mldsa.key \
        -dcert localhost-rsa.crt -dkey localhost-rsa.key
}

function start-server-with-mldsa-certificate {
    "${OPENSSL_CLI}" s_server \
        -cert localhost-mldsa.crt -key localhost-mldsa.key
}

function start-server-with-rsa-certificate {
    "${OPENSSL_CLI}" s_server \
        -cert localhost-rsa.crt -key localhost-rsa.key
}

function connect-mldsa {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-mldsa.crt </dev/null
}

function connect-rsa {
    "${OPENSSL_CLI}" s_client \
        -connect localhost:4433 \
        -CAfile localhost-rsa.crt \
        -sigalgs 'rsa_pss_pss_sha256:rsa_pss_rsae_sha256' </dev/null
}

if [ "${#}" -lt 1 ]; then
    usage
    exit 1
fi

cmd="${1}"
case "${cmd}" in
generate-keys-certs)
    generate-keys-certs
    ;;
start-dual-cert-server)
    start-server-with-dual-certificates
    ;;
start-mldsa-cert-server)
    start-server-with-mldsa-certificate
    ;;
start-rsa-cert-server)
    start-server-with-rsa-certificate
    ;;
connect-mldsa)
    connect-mldsa
    ;;
connect-rsa)
    connect-rsa
    ;;
*)
    usage
    exit 2
esac

echo "OK"
