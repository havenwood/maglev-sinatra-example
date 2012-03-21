require 'rubygems'
require 'sinatra'
require 'mag'

# some Maglev-specific preparation for Sinatra
configure(:development) do
  set :sessions, true
  set :run,      true unless defined? DO_NOT_RUN
  set :server,   'webrick'
end

get '/' do
  Mag.abort

  unless Mag.box
    Mag.box = {}
    Mag.commit
  end
  
  unless Mag.box[:people].kind_of? Array
    Mag.box[:people] = []
    Mag.commit
  end
  
  erb :index
end

post '/' do
  name = params[:name]
  
  redirect '/' if name.empty? #TODO: return http error
  
  name.capitalize!

  Mag.abort

  if Mag.box[:people].include? name
    #TODO: return http error
  else
    Mag.box[:people] << name
    Mag.box[:people].sort!
    Mag.commit
  end

  redirect '/'
end

post '/remove' do
  name = params[:name]
  
  redirect '/' if name.empty? #TODO: return http error
  
  Mag.abort

  if Mag.box[:people].include? name
    Mag.box[:people].delete name
    Mag.commit
  else
    #TODO: return http error
  end

  redirect '/'
end

__END__

@@layout
<!DOCTYPE html>
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
<section>
  <h1>People</h1>
  <ul>
    <% unless Mag.box[:people].empty? %>
      <% Mag.box[:people].each do |person| %>
        <li><%= "#{person}" %></li>
      <% end %>
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