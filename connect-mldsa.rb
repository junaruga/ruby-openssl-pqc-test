require 'openssl'
require 'socket'

tcp_sock = nil
ssl_sock = nil
begin
  tcp_sock = TCPSocket.new("127.0.0.1", 4433)
  ctx = OpenSSL::SSL::SSLContext.new
  mldsa_cert = OpenSSL::X509::Certificate.new File.read("localhost-mldsa.crt")
  ctx.cert = mldsa_cert
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
