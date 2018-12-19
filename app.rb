require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Комната мастера'
  end
end


get '/' do
  erb ''
end

get '/about' do
  erb :about
end

get '/visits' do
  erb :visits
end
post '/visits' do
  @cliento = params[:exampleFormControlInput1]
  @time = params[:exampleFormControlInput2]
  @phone = params[:exampleFormControlInput3]
  @master = params[:exampleFormControlSelect1]
  @color = params[:color]

  hh = {:exampleFormControlInput1 => 'Введите имя',
          :exampleFormControlInput2 => 'Ввыберите дату и время',
          :exampleFormControlInput3 => 'Введите номер телефона'}

  hh.each do |key, value|
      if params[key] == ''
      @error = hh[key]
      return   erb :visits
    end
  end

  list = File.open("./public/zapis.txt", "a")
  list.puts "(Time: #{@time}) (client: #{@cliento}) (phone:#{@phone})(master:#{@master}) color: #{@color}"
  list.close
  list.close
  erb "Dear #{@cliento}, We will wait you #{@time}"
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
  @admin = params[:username]
  @adminpass = params[:password]
  session[:identity] = params['username']
  if @admin == "cheburashka" && @adminpass == "urbechkasha"
  erb :ogo
else
  erb :about
end

end

post '/access_to_secret_place' do
@logfile = File.read("./public/zapis.txt")
  erb :secret
end


get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end
