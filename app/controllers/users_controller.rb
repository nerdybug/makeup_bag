class UsersController < ApplicationController

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
end
