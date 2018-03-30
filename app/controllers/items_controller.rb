class ItemsController < ApplicationController

  get '/items/add' do
    @user = User.find_by(id: session[:user_id])
    erb :'items/add'
  end

  post '/items' do
    @user = User.find_by(id: session[:user_id])
    @item = Item.create(params[:item])
    @item.user_id = @user.id
    @item.save
    binding.pry
    erb :'users/show'
  end
end
