require 'sinatra'
require './static/validator.rb'

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"
enable :sessions

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
