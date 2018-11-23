$stdout.sync = true
####################################################################################################
# @author       David Kirwan https://github.com/davidkirwan/reservation_system
# @description  Create a reservation for some resource
#
# @date         2018-11-23
####################################################################################################
##### Require statements
require 'sinatra/base'
require 'logger'
require 'json'
require 'puma'
require File.join(File.dirname(__FILE__), '/lib/api')


module Clusterlist
class App < Sinatra::Base
  ##### Variables
  enable :static, :sessions, :logging
  set :server, :puma
  set :environment, :production
  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, '/public')
  set :views, File.join(root, '/views')

  # Create the logger instance
  set :log, Logger.new(STDOUT)
  set :level, Logger::DEBUG
  #set :level, Logger::INFO
  #set :level, Logger::WARN

  # Options hash
  set :options, {:log => settings.log, :level => settings.level}
#########################################################################################################
  API.load_reservations()

  four_oh_four_messages = [
    "404 listen Linda",
    "404 Linda listen!",
    "404 Stahp would ya"
  ]

  not_found do
    [404, {"Content-Type" => "text/plain"},[four_oh_four_messages.sample]]
  end

  get '/' do
    reservations = API.list_reservations()
    settings.log.debug reservations
    erb :index, :locals => {:reservations => reservations}
  end

  # Create reservation form
  get '/reservations/:resource/new' do |resource|
    settings.log.debug "GET /reservations/#{resource}/new"
    erb :create_reservation, :locals => {:resource => resource}
  end

  # Create reservation
  post '/reservations/:resource' do |resource|
    settings.log.debug "POST /reservations/#{resource} " + params.inspect
    result = API.create_reservation(params, resource)
    settings.log.debug result
  end

  # Delete reservation
  delete '/reservations/:resource' do |resource|
    settings.log.debug "DELETE /reservations/#{resource}"
    result = API.delete_reservation(params, resource)
    settings.log.debug result
  end
end # End of the App class
end # End of the Clusterlist module
