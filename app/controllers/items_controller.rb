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
      create_item(params)
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

    if @user.id != @item.user_id
      flash[:wrong_user] = "That item was not yours. Review your items below."
      redirect '/bag'
    end

    if !valid?(params[:item])
      flash[:error] = "You entered invalid data. Please try again."
      redirect "/items/#{@item.id}/edit"
    elsif params.include?("item_type") && !params[:item][:type_of_item].empty? && !params[:item_type].empty?
    	flash[:multiple] = "You cannot enter more than one type or brand. Please try again."
    	redirect "/items/#{@item.id}/edit"
    elsif params.include?("item_type")
      @item.update(type_of_item: params[:item_type])
    else
      params[:item].each {|k,v| @item.update("#{k}": "#{v}") if v != "" && k != "favorite" && k != "need_more"}
    end

    if params.include?("brand") && !valid?(params[:brand])
      flash[:error] = "You entered invalid data. Please try again."
      redirect "/items/#{@item.id}/edit"
    elsif params.include?("brand_name") && !params[:brand][:name].empty? && !params[:brand_name].empty?
      flash[:multiple] = "You cannot enter more than one type or brand. Please try again."
      redirect "/items/#{@item.id}/edit"
    elsif params.include?("brand_name")
      @brand = Brand.find_or_create_by(name: params[:brand_name])
      @item.update(brand_id: @brand.id)
      @item.brands << @brand
    else
      @brand = Brand.find_or_create_by(name: params[:brand][:name])
      @item.update(brand_id: @brand.id)
      @item.brands << @brand
    end
    handle_booleans(params[:item])
    redirect "/items/#{@item.id}"
  end

  get '/items/:id/delete' do
    @item = Item.find_by(id: params[:id])
    @item.destroy
    flash[:deleted] = "The item was deleted."
    redirect '/bag'
  end

  helpers do
    def handle_booleans(params)
      if !params.include?("favorite") && @item.favorite
        @item.update(favorite: false)
      elsif params.include?("favorite") && !@item.favorite
        @item.update(favorite: true)
      end

      if !params.include?("need_more") && @item.need_more
        @item.update(need_more: false)
      elsif params.include?("need_more") && !@item.need_more
        @item.update(need_more: true)
      end
    end

    def create_item(params)
      @item = Item.create(params[:item])
      @item.update(user_id: @user.id)
      if @item.color == ""
        @item.update(color: "none")
      end
      @brand = Brand.find_or_create_by(name: params[:brand][:name])
      @item.update(brand_id: @brand.id)
      @item.brands << @brand
    end
  end
end
