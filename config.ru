require 'pg'
require 'bundler/setup'
require 'pry'
require 'redcarpet'

require "sinatra/base"
#require "sinatra/reloader"
require_relative "server"
run Sinatra::Server
