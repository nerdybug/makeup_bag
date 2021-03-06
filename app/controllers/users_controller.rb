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
    elsif !@user
      flash[:no_user] = "That user does not exist. Please try again."
      redirect '/login'
    else
      flash[:wrong_password] = "The password you entered was not correct. Please try again."
      redirect '/login'
    end
  end

  get '/bag' do
    @user = get_user
    @items = @user.items
    erb :'users/show'
  end

  get '/order/:column/:direction' do
    @user = get_user
    @items = @user.items

    if !params[:column].include?("brand")
      @items = @user.items.order("#{params[:column]} #{params[:direction]}")
    elsif params[:direction] == "desc"
      @names_in_order = collect_names(@items).sort {|x,y| y <=> x}
      @ordered_items = items_ordered_by(@names_in_order)
      @items = @ordered_items
    else
      @names_in_order = collect_names(@items).sort
      @ordered_items = items_ordered_by(@names_in_order)
      @items = @ordered_items
    end
    erb :'users/show'
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/bag' do
    @user = get_user
    erb :'users/show'
  end

  helpers do
    def collect_names(items_array) # return array with the brand names of each item
      @names = []
      items_array.each {|item| @names << get_brand_name(item.brand_id)}
      @names
    end

    def items_ordered_by(names_in_order) # return array of brand names in either asc or desc order
      @new = []
      names_in_order.each do |name|
        @brand = Brand.find_by(name: name)
        @result = @items.select {|item| item.brand_id == @brand.id}
        if !@result.is_a? Array
          @new << @result
        else
          @result.each {|item| @new << item if !@new.include?(item)}
        end
      end
      @new
    end
  end
end
