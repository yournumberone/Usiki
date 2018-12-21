require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
  enable :sessions
end

def get_base
  db = SQLite3::Database.new "shopbase.db"
  db.results_as_hash = true
  return db
end

configure do
    baseus = get_base
    baseus.execute 'CREATE TABLE IF NOT EXISTS "Clients"
    ("name" TEXT,
    "phone" TEXT,
    "datetime" TEXT,
    "master" TEXT)'
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
  baseus = get_base
  baseus.execute("insert into Clients values (?, ?, ?, ?)", [@cliento, @phone, @time, @master])
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
@fefile = get_base
erb :secret
end


get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end
