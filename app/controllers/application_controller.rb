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

    def valid?(params_hash) # TRUE if params are valid (i.e. containing no special characters)
      strip_string_params(params_hash)
      !params_hash.any? {|k,v| v =~ /[^a-zA-Z\d\s]/}
    end

    def blank?(params_hash) # TRUE if params have blank values
      params_hash.any? {|k,v| v == "" if k != "color"}
    end

    def get_brand_name(brand_id)
    	Brand.find_by(id: brand_id).name
    end
  end
end
