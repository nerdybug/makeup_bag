require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    erb :index
  end
  
  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do
    @user = User.create(params)
    session[:user_id] = @user.id
    erb :'users/show'
  end
end
