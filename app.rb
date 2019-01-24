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
  erb :new_form
end

#Show route
get '/members/:name' do
  @name = params[:name]
  erb :show
end

#Create route
post '/members' do
  @name = params[:name]
end
