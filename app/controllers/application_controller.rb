require './config/environment'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
    register Sinatra::Flash # needed for sinatra-flash
  end

  get '/' do
    erb :index
  end

  helpers do
    def strip_string_params(params_hash)
    	params_hash.each do |k,v|
    		params_hash[k] = v.strip
    	end
    end

    def valid?(params_hash) # TRUE if params are valid (i.e. containing no special characters)
      strip_string_params(params_hash)
      !params_hash.any? {|k,v| v =~ /[^a-zA-Z\d\s]/}
    end

    def blank?(params_hash) # TRUE if params have blank values
      params_hash.any? {|k,v| v == "" if k != "color"}
    end

    def get_user
      User.find_by(id: session[:user_id])
    end

    def get_brand_name(brand_id)
    	Brand.find_by(id: brand_id).name
    end

    def collect_names(items_array)
    	@names = []
    	items_array.each {|item| @names << get_brand_name(item.brand_id)}
    	@names
    end
    def items_ordered_by(names_in_order)
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
