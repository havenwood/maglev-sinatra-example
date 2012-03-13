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

post '/' do
  name = params[:name]

  redirect '/' if name.empty? #TODO: return appropriate http error

  name.capitalize!

  Mag.pull

  if Mag.box[:people].include? name
    #TODO: return appropriate http error
  else
    Mag.box[:people] << name
    Mag.box[:people].sort!
    Mag.commit
  end

  redirect '/'
end

post '/remove' do
  name = params[:name]

  redirect '/' if name.empty? #TODO: return appropriate http error

  name.capitalize!

  Mag.pull

  if Mag.box[:people].include? name
    Mag.box[:people].delete(name)
    Mag.commit
  else
    #TODO: return appropriate http error
  end

  redirect '/'
end

__END__

@@layout
<!DOCTYPE html>
<html lang='en' xmlns='http://www.w3.org/1999/xhtml' xml:lang='en'>
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
<section>
  <h1>People</h1>
  <ul>
    <% Mag.box[:people].each do |person| %>
      <li><%= "#{person}" %></li>
    <% end %>
  </ul>
</section>
<section>
  <form action='/' method='post'>
    <input type='text' name ='name' placeholder='First name' />  
    <button type='submit'>Add</button>
  </form>
</section>
<section>
  <form action='/remove' method='post'>
    <input type='text' name ='name' placeholder='First name' />  
    <button type='submit'>Remove</button>
  </form>
</section>