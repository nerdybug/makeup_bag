class ItemsController < ApplicationController

  get '/items/add' do
    @user = get_user
    erb :'items/add'
  end

  get '/error' do
    erb :'items/error'
  end

  post '/items' do
    @user = get_user
    if !valid?(params[:item]) || !valid?(params[:brand]) || blank?(params[:brand]) || blank?(params[:item])
      flash.now[:error] = "You entered invalid data. Please try again."
      erb :'items/add'
    elsif @user.items.any? {|item| item.name.match /#{params[:item][:name]}/i}
      flash[:exists] = "That item already exists."
      redirect "/items/#{@user.items.select {|item| item.name.match /#{params[:item][:name]}/i}[0].id}"
    else
    	@item = Item.create(params[:item])
      @item.update(user_id: @user.id)
      @brand = Brand.find_or_create_by(name: params[:brand][:name])
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
    @user = get_user
    @item = Item.find_by(id: params[:id])
    erb :'items/edit'
  end

  patch '/items/:id' do
    @user = get_user
    @item = Item.find_by(id: params[:id])

    if !valid?(params[:item])
      flash[:error] = "You entered invalid data. Please try again."
      redirect "/items/#{@item.id}/edit"
    else
      params[:item].each {|k,v| @item.update("#{k}": "#{v}") if v != "" && k != "favorite" && k != "need_more"}
    end

    if params.include?("brand") && !valid?(params[:brand])
      flash[:error] = "You entered invalid data. Please try again."
      redirect "/items/#{@item.id}/edit"
    elsif !blank?(params[:brand])
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
