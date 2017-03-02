#!/usr/bin/env ruby

require "yaml"
require "cgi"
require_relative '../utility.rb'
@config = read_YAML("config.yml")

project  = CGI::unescape ARGV[0]
user 	 = ARGV[1]
repo 	 = ARGV[2]
desc 	 = CGI::unescape ARGV[3]
root 	 = ARGV[4]
old 	 = CGI::unescape ARGV[5]

projects = read_YAML(@config["database"])
projects = projects.select { |e| e["project"] != old }
projects.push({'repo' => repo, 'project' => project, 'user' => user, 'desc' => desc, 'root' => root})
write_YAML @config["database"], projects

Dir.chdir("#{@config['projects']}")
puts `mv #{old} #{project}`