require 'dashing'
require './lib/mycloud' 

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'
  set :blah, "This is a test"
  set :num, MyCloud.num

  

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end


map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
