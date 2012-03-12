require 'rubygems'
require 'sinatra'
require 'mag'

configure(:development) do
  set :sessions, true
  set :run,      true unless defined? DO_NOT_RUN
  set :server,   'webrick'
end

get '/' do
  erb :index
end

get '/people' do
  Mag.pull
  erb :people
end

get '/person/add' do
  Mag.pull
  erb :add
end

post '/person/add' do
  name = params[:name].split.first

  redirect '/person/add' if name.nil? #this seems very wrong... return 40X?

  name.capitalize!

  Mag.pull

  unless Mag.box[:people].include? name
    Mag.box[:people] << name
    Mag.commit
  end

  redirect '/person/add'
end

get '/person/remove' do
  Mag.pull
  erb :remove
end

post '/person/remove' do
  name = params[:name].split.first

  redirect 'person/remove' if name.nil?

  name.capitalize!

  Mag.pull

  if Mag.box[:people].include? name
    Mag.box[:people].delete(name)
    Mag.commit
  end

  redirect '/person/remove'
end

__END__

@@layout
<!doctype html>
<html lang='en'>
<head>
  <title>API</title>
  <meta charset='utf-8' />
</head>
<body>
  <section>
    <%= yield %>
  </section>
</body>
</html>

@@index
<h1>Peeps</h1>
<nav>
  <li><a href='/person/add'>Add Person</a></li>
  <li><a href='/person/remove'>Remove Person</a></li>
</nav>

@@add
<h1>Add Person</h1>
<p>
  <% Mag.box[:people].each do |person| %>
    <li><%= "#{person}" %></li>
  <% end %>
</p>
<form action='/person/add' method='post'>
  <input type='text' name ='name' placeholder='First name&hellip;'></input>  
  <input type='submit' value='Add'>
</form>
<p><a href='/'>Back</a></p>

@@remove
<h1>Remove Person</h1>
<p>
  <% Mag.box[:people].each do |person| %>
    <li><%= "#{person}" %></li>
  <% end %>
</p> 
<form action='/person/remove' method='post'>
  <input type='text' name ='name' placeholder='First name&hellip;'></input>  
  <input type='submit' value='Remove'>
</form>
<p><a href='/'>Back</a></p>