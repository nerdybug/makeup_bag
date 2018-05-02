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
    if !valid?(params[:item]) || !valid?(params[:brand])
      flash.now[:error] = "You entered invalid data. Please try again without special characters."
      erb :'items/add'
    else
    	@item = Item.create(params[:item])
      @item.update(user_id: @user.id)
      @brand = Brand.find_or_create_by(name: params[:brand][:name])
      binding.pry
      @item.update(brand_id: @brand.id)
      @item.brands << @brand
      redirect '/bag'
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
    @user = User.find_by(id: session[:user_id])
    @item = Item.find_by(id: params[:id])

    if !valid?(params[:item])
      flash[:error] = "You entered invalid data. Please try again without special characters."
      redirect "/items/#{@item.id}/edit"
    else
      params[:item].each {|k,v| @item.update("#{k}": "#{v}") if v != "" && k != "favorite" && k != "need_more"}
    end

    if params.include?("brand") && !params[:brand][:name].empty? && !valid?(params[:brand])
      flash[:error] = "You entered invalid data. Please try again without special characters."
      redirect "/items/#{@item.id}/edit"
    else
      @brand = Brand.find_or_create_by(name: params[:brand][:name])
      @item.update(brand_id: @brand.id)
      @item.brands << @brand
    end

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

    redirect "/items/#{@item.id}"
  end

  get '/items/:id/delete' do
    @item = Item.find_by(id: params[:id])
    @item.destroy
    flash[:deleted] = "The item was deleted."
    redirect '/bag'
  end
end
