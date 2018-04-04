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
    @item = Item.find_by(id: params[:id])
    erb :'items/edit'
  end
end
