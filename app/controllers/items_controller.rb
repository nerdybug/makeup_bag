class ItemsController < ApplicationController

  get '/items/add' do
    @user = User.find_by(id: session[:user_id])
    erb :'items/add'
  end

  get '/error' do
    erb :'items/error'
  end

  post '/items' do
    @user = User.find_by(id: session[:user_id])
    strip_string_params(params[:item])
    if valid?(params[:item]) || valid?(params[:brand])
    	redirect '/error'
    else
    	@item = Item.create(params[:item])
    	@brand = Brand.create(strip_string_params(params[:brand]))
      @item.update(user_id: @user.id)
      @brand = Brand.create(strip_string_params(params[:brand]))
      @item.update(brand_id: @brand.id)
      @item.brands << @brand
      erb :'users/show'
    end
  end

  get '/items/:id' do
    @item = Item.find_by(id: params[:id])
    erb :'items/show'
  end

  get '/items/:id/edit' do
    @user = User.find_by(id: session[:user_id])
    @item = Item.find_by(id: params[:id])
    erb :'items/edit'
  end

  patch '/items/:id' do
    @item = Item.find_by(id: params[:id])
    params[:item].each {|k,v| @item.update("#{k}": "#{v}") if v != "" && k != "favorite" && k != "need_more"}

    if !params[:item].include?("favorite") && @item.favorite
      @item.update(favorite: false)
    elsif params[:item].include?("favorite") && !@item.favorite
      @item.update(favorite: true)
    end
    if !params[:item].include?("need_more") && @item.need_more
      @item.update(need_more: false)
    elsif params[:item].include?("need_more") && !@item.need_more
      @item.update(need_more: true)
    end

    if params.include?("brand") && !params[:brand][:name].empty?
      @brand = Brand.create(params[:brand])
      @item.update(brand_id: @brand.id)
      @item.brands << @brand
    end
    redirect "/items/#{@item.id}"
  end
end
