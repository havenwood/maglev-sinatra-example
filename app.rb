require 'rubygems'
require 'sinatra'
require 'mag' #tiny helper library to abbreviate Maglev commands to Mag

<<<<<<< HEAD
## A bit of Maglev-specific configuration for Sinatra
#
=======
# some Maglev-specific preparation for Sinatra
>>>>>>> e2f5758e37d944c20cec0508cd21513f3a31f819
configure(:development) do
  set :sessions, true
  set :run,      true unless defined? DO_NOT_RUN
  set :server,   'webrick'
end

get '/' do
<<<<<<< HEAD
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
=======
  Mag.abort

  unless Mag.box
    Mag.box = {}
    Mag.commit
  end
  
  unless Mag.box[:people].kind_of? Array
    Mag.box[:people] = []
    Mag.commit
  end
  
>>>>>>> e2f5758e37d944c20cec0508cd21513f3a31f819
  erb :index
end

post '/' do
  name = params[:name]
<<<<<<< HEAD
  redirect '/' if name.empty?
=======
  
  redirect '/' if name.empty? #TODO: return http error
  
>>>>>>> e2f5758e37d944c20cec0508cd21513f3a31f819
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
<<<<<<< HEAD
  redirect '/' if name.empty?
  name.capitalize!
  Mag.abort

  if Mag.store[:people].include? name
    Mag.store[:people].delete(name)
=======
  
  redirect '/' if name.empty? #TODO: return http error
  
  Mag.abort

  if Mag.box[:people].include? name
    Mag.box[:people].delete name
>>>>>>> e2f5758e37d944c20cec0508cd21513f3a31f819
    Mag.commit
  end

  redirect '/'
end

__END__

@@layout
<<<<<<< HEAD
<!doctype html>
=======
<!DOCTYPE html>
>>>>>>> e2f5758e37d944c20cec0508cd21513f3a31f819
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
<<<<<<< HEAD
		<% Mag.store[:people].each do |person| %>
    	<li><%= "#{person}" %></li>
  	<% end %>
=======
    <% unless Mag.box[:people].empty? %>
      <% Mag.box[:people].each do |person| %>
        <li><%= "#{person}" %></li>
      <% end %>
    <% end %>
>>>>>>> e2f5758e37d944c20cec0508cd21513f3a31f819
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