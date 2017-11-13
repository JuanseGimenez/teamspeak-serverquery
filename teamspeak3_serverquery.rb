#!/usr/bin/env ruby
require 'net/telnet'

# Generate connection with the server and exit execution if fail
def connection(host, port)
	begin
	  @connection = Net::Telnet::new(
         "Host"       => "#{host}",
         "Port"       => "#{port}",
         "Prompt"     => /[$%#>] \z/n,
         "Telnetmode" => true,
         "Timeout"    => 10
       )
	rescue
	  puts "Error with the server, try again"
	  exit
	end
end

# Use cmd command for Telnet
def command(param)
	if param == "exit"
		disconnect
	else
		@connection.cmd('String'  => "#{param}\r",'Match' => /error id=0 msg=ok\n/,'Timeout' => 3)
	end
end

# Login into server with user and password
def login(user, password)
	@connection.cmd('String'  => "login #{user} #{password}\r",'Match' => /error id=0 msg=ok\n/, 'Timeout' => 3)
end

# Query parse to hash
def parse_result(param)
	Hash[param.scan /([^=]+)=([^ ]+)[ $]/]
end

# Simple each to see data
def show_data(param)
	param.each do |k,v|
		puts "#{k} : #{v}"
	end
end

def simple_show(param)
	puts param
end

def disconnect
	@connection.close
	puts "Disconnect from thr server, Thx"
end

puts "Program created by Juanse 2017"

# Connection with server
print "Server ip or domain: "
server = gets.chomp
print "Port server: "
port = gets.chomp
connection(server,port)

# Log with user and password
print "Username: "
username = gets.chomp
print "Password: "
password = gets.chomp
login(username,password)

# Get server info
command("use 1")
serverinfo = command("serverinfo")
show_data(parse_result(serverinfo))


# Commands
cmd = ""
while cmd != "exit"
	print "Write a command, write help if you do not know any: "
	cmd = gets.chomp.downcase
	result = command(cmd)
	simple_show(result)
end