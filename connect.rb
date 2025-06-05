require 'openssl'
require 'socket'

def print_usage
  puts <<EOF
Usage #{$PROGRAM_NAME} [mldsa|rsa]
EOF
end

if ARGV.length < 1
  print_usage
  abort
end
crypto=ARGV[0]
# puts "crypto: #{crypto}"

tcp_sock = nil
ssl_sock = nil
begin
  tcp_sock = TCPSocket.new("127.0.0.1", 4433)
  ctx = OpenSSL::SSL::SSLContext.new
  case crypto
  when "mldsa"
    nil
  when "rsa"
    ctx.client_sigalgs = "rsa_pss_pss_sha256:rsa_pss_rsae_sha256"
    # ctx.client_sigalgs = "RSA-PSS+SHA256"
  else
    print_usage
    raise
  end
  ctx.ca_file = "localhost-#{crypto}.crt"

  ssl_sock = OpenSSL::SSL::SSLSocket.new(tcp_sock, ctx)
  ssl_sock.sync_close = true
  ssl_sock.connect
  # pp ssl_sock
  puts "SSL Version: #{ssl_sock.ssl_version}"
  puts "Cert: #{ssl_sock.cert}"
  puts "Cipher: #{ssl_sock.cipher}"
ensure
  ssl_sock.close if ssl_sock
  tcp_sock.close if tcp_sock
end
