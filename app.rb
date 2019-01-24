require 'sinatra'
require './static/validator.rb'

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"
enable :sessions
use Rack::MethodOverride

def show_names(filename)
  File.read('static/' + filename).split("\n")
end

#Index route
get '/members' do
  @members = show_names('members.txt')
  erb :index
end

#New route
get '/members/new' do
  @message = session[:message]
  erb :new_form
end

#Show route
get '/members/:name' do
  @message = session[:message]
  @name = params[:name]
  erb :show
end

#Create route
post '/members' do
  @name = params[:name]

  if @name.to_s.empty?
    session[:message] = "Name can't be empty."
    redirect '/members/new'
  elsif show_names('members.txt').include?(@name)
    session[:message] = "That name already exists"
    redirect '/members/new'
  else
    session[:message] = "Success. New member created."
    redirect '/members/' + @name
  end
end

#edit route
get '/members/:name/edit' do
  @name = params[:name]
  @message = session.delete(:message)
  erb :edit_form
end

#update route
put '/members/:name' do
  @name = params[:name]
  @new_name = params[:new_name]
  p params

  if @new_name.to_s.empty?
    session[:message] = "Name can't be empty."
    redirect '/members/' + @name + '/edit'
  elsif show_names('members.txt').include?(@new_name)
    session[:message] = "That name is the same."
    redirect '/members/' + @name + '/edit'
  else
    session[:message] = "Success. Name Updated."
    redirect '/members/' + @new_name
  end
end

get '/members/:name/delete' do
  @name = params[:name]
  erb :delete_form
end

delete '/members/:name' do
  @name = params[:name]
  @name_list = show_names('members.txt')
  @name_list.delete(@name)
  @name_list = @name_list.join("\n")
  File.open('./static/members.txt', 'w') { |f| f.puts @name_list }
  redirect '/members'
end
