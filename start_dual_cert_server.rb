# frozen_string_literal: true

require 'openssl'
require 'socket'

def print_usage
  puts <<~USAGE
    Usage #{$PROGRAM_NAME} [group]
  USAGE
end

group = if ARGV.length >= 1
          ARGV[0]
        else
          'X25519MLKEM768'
        end

# puts "group: #{group}"

ctx = OpenSSL::SSL::SSLContext.new
mldsa_key = OpenSSL::PKey.read(File.read('localhost-mldsa.key'))
mldsa_cert = OpenSSL::X509::Certificate.new(File.read('localhost-mldsa.crt'))
rsa_key = OpenSSL::PKey.read(File.read('localhost-rsa.key'))
rsa_cert = OpenSSL::X509::Certificate.new(File.read('localhost-rsa.crt'))
# ctx.key = mldsa_key
# ctx.cert = mldsa_cert
ctx.add_certificate(mldsa_cert, mldsa_key)
ctx.add_certificate(rsa_cert, rsa_key)

case group
when 'X25519MLKEM768'
  nil
when 'SecP256r1MLKEM768', 'SecP384r1MLKEM1024'
  ctx.ecdh_curves = group
else
  print_usage
  abort
end

tcp_server = TCPServer.new('127.0.0.1', 4433)
ssl_server = OpenSSL::SSL::SSLServer.new(tcp_server, ctx)
begin
  loop do
    ssl_connection = nil
    begin
      ssl_connection = ssl_server.accept
      data = ssl_connection.gets
      # pp ssl_connection, ssl_server
      puts "Client sent data:\n#{data.dump}" if data
    ensure
      ssl_connection&.close
    end
  end
ensure
  tcp_server&.close
end
