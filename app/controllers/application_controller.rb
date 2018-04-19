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
    @taken = User.find_by(username: params[:username])
    if @taken
      erb :'users/taken'
    else
      @user = User.create(params)
      session[:user_id] = @user.id
      erb :'users/show'
    end
  end

  get '/login' do
    erb :'users/login'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/bag'
    else
      redirect '/login'
    end
  end

  get '/bag' do
    @user = User.find_by(id: session[:user_id])
    erb :'users/show'
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/bag' do
    @user = User.find_by(id: session[:user_id])
    erb :'users/show'
  end

  helpers do
    def strip_string_params(params_hash)
    	params_hash.each do |k,v|
    		params_hash[k] = v.strip
    	end
    end

    def valid?(params_hash)
      params_hash.any? {|k,v| v =~ /[^a-zA-Z\d\s]/} # returns false if no matches
    end
  end
end
