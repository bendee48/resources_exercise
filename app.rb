require 'sinatra'

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"
enable :sessions

def show_names(filename)
  File.read('static/' + filename).split("\n")
end

#Index
get '/members/' do
  @members = show_names('members.txt')
  erb :index
end

#Show
get '/members/:name' do
  @name = params[:name]
  erb :show
end
