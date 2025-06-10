# frozen_string_literal: true

require 'openssl'
require 'socket'

def print_usage
  puts <<~USAGE
    Usage #{$PROGRAM_NAME} [mldsa|rsa] [group]
  USAGE
end

if ARGV.empty?
  print_usage
  abort
end
crypto = ARGV[0]
if ARGV.length >= 2
  group = ARGV[1]
else
  group = 'X25519MLKEM768'
end
# puts "crypto: #{crypto}"
# puts "group: #{group}"

tcp_sock = nil
ssl_sock = nil
begin
  tcp_sock = TCPSocket.new('127.0.0.1', 4433)
  ctx = OpenSSL::SSL::SSLContext.new
  case crypto
  when 'mldsa'
    nil
  when 'rsa'
    ctx.sigalgs = 'rsa_pss_rsae_sha256'
  when 'rsa-pss'
    ctx.sigalgs = 'rsa_pss_pss_sha256'
  else
    print_usage
    raise
  end
  case group
  when 'X25519MLKEM768'
    nil
  when 'SecP256r1MLKEM768', 'SecP384r1MLKEM1024'
    ctx.ecdh_curves = group
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
  ssl_sock&.close
  tcp_sock&.close
end
