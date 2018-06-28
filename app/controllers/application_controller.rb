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
    def get_user
      User.find_by(id: session[:user_id])
    end
    def get_brand_name(brand_id)
      Brand.find_by(id: brand_id).name
    end
  end
end
