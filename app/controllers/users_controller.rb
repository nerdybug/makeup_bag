class UsersController < ApplicationController

  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do
    params[:username] = params[:username].strip

    if User.any? {|user| user.username.match /#{params[:username]}/i}
      flash.now[:taken] = "That username is taken. Please try again."
      erb :'users/signup'
    else
      @user = User.create(params)
      session[:user_id] = @user.id
      @items = @user.items
      erb :'users/show'
    end
  end

  get '/login' do
    erb :'users/login'
  end

  post '/login' do
    params[:username] = params[:username].strip

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
    @items = @user.items
    erb :'users/show'
  end

  get '/order/:column/:direction' do
    @user = User.find_by(id: session[:user_id])
    @items = @user.items.order("#{params[:column]} #{params[:direction].upcase}")
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
