require 'rubygems'
require 'sinatra'
require 'mag' #tiny helper library to abbreviate Maglev commands to Mag

## A bit of Maglev-specific configuration for Sinatra
#
configure(:development) do
  set :sessions, true
  set :run,      true unless defined? DO_NOT_RUN
  set :server,   'webrick'
end

get '/' do
  ## Abort transaction to get latest store
  #
  Mag.abort
	
  ## If store is empty, make a Hash
  #
  Mag.store ||= {} && Mag.commit
	
  ## If store Hash doesn't have a :people key, make it
  #
  unless Mag.store[:people].kind_of? Array
		Mag.store[:people] = []
		Mag.commit
	end

  ## Render page
  #
  erb :index
end

post '/' do
  name = params[:name]
  redirect '/' if name.empty?
  name.capitalize!
  Mag.abort

  if Mag.store[:people].include? name
    redirect back
  else
    Mag.store[:people] << name
    Mag.store[:people].sort!
    Mag.commit
  end

  redirect '/'
end

post '/remove' do
  name = params[:name]
  redirect '/' if name.empty?
  name.capitalize!
  Mag.abort

  if Mag.store[:people].include? name
    Mag.store[:people].delete(name)
    Mag.commit
  end

  redirect '/'
end

__END__

@@layout
<!doctype html>
<html lang='en'>
<head>
  <title>Maglev-Sinatra</title>
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
		<% Mag.store[:people].each do |person| %>
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