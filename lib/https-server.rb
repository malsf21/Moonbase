require 'socket'
require 'openssl'
require_relative './utility.rb'

# Load config
config = read_YAML("config.yml")

class Server
	def initialize(address, port)
		@address = address
		@port = port
	end

	def start
		# Make TCP socket (same as http)
		tcps = TCPServer.new(@address, @port)

		# Load up certs
		ssl_context = OpenSSL::SSL::SSLContext.new()
		ssl_context.cert = OpenSSL::X509::Certificate.new(File.open(config['cert']))
		ssl_context.key = OpenSSL::PKey::RSA.new(File.open(config['key']))
		ssl_context.ssl_version = :SSLv23

		ssls = OpenSSL::SSL::SSLServer.new(tcps, ssl_context)
		ssls.start_immediately = true

		# Send it off
		print "server @ https://#{@address}:#{@port}\n"
		return ssls
	end
end