require 'rest_client' 
require 'json' 

token = "<your token>" 

#response = RestClient::Request.execute(:method => :get, :content_type => :json, :accept => :json, :url => 'http://localhost:8777/v2/meters/cpu_util', :headers => { 'X-Auth-Token' => "#{token}"})

response1= RestClient.get("http://localhost:8777/v2/meters/cpu_util/statistics", { 'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })

#puts response1

result = JSON.parse(response1) 

diskread = RestClient.get("http://localhost:8777/v2/meters/network.incoming.bytes/statistics", { 'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })

diskread = JSON.parse(diskread) 

puts diskread[0]['sum'] 
#puts result[0]['avg'] 
