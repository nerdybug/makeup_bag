require './config/environment'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
    register Sinatra::Flash # needed for sinatra-flash
  end

  get '/' do
    erb :index
  end

  helpers do
    def strip_string_params(params_hash)
    	params_hash.each do |k,v|
    		params_hash[k] = v.strip
    	end
    end

    def valid?(params_hash)
      params_hash.any? {|k,v| v =~ /[^a-zA-Z\d\s]/} # returns false if no match
    end
  end
end
