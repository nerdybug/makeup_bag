class ItemsController < ApplicationController

  get '/items/add' do
    @user = User.find_by(id: session[:user_id])
    erb :'items/add'
  end

  post '/items' do
    @user = User.find_by(id: session[:user_id])
    @item = Item.create(params[:item])
    @item.update(user_id: @user.id)
    binding.pry
    erb :'users/show'
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

    # if params[:item][:name] != ""
    # 	@item.update(name: params[:item][:name])
    # end
    # if params[:item][:type_of_item] != ""
    # 	@item.update(type_of_item: params[:item][:type_of_item])
    # end
    # if params[:item][:color] != ""
    # 	@item.update(color: params[:item][:color])
    # end
    # if params[:item][:favorite] != ""
    #   @item.update(favorite: params[:item][:favorite])
    # end
    # if params[:item][:need_more] != ""
    #   @item.update(need_more: params[:item][:need_more])
    # end
    redirect "/items/#{@item.id}"
  end
end
