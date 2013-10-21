require 'rest_client' 
require 'json' 


#response = RestClient::Request.execute(:method => :get, :content_type => :json, :accept => :json, :url => 'http://localhost:8777/v2/meters/cpu_util', :headers => { 'X-Auth-Token' => "#{token}"})

#response1= RestClient.get("http://localhost:8777/v2/meters/cpu_util/statistics", { 'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })

#puts response1

#result = JSON.parse(response1) 

#diskread = RestClient.get("http://localhost:8777/v2/meters/network.incoming.bytes/statistics", { 'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })

#diskread = JSON.parse(diskread) 

#puts diskread[0]['sum'] 
#puts result[0]['avg'] 
#
token = ENV['TOKEN'] 

numOfInstances = RestClient.get("http://localhost:8774/v2/007589e7f70f406db10e3aabdae3c39f/servers/detail", {'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json}) 
numOfInstances = JSON.parse(numOfInstances) 
num = 0 

numOfInstances["servers"].each do |instance| 
    puts instance["status"]
    puts instance["OS-EXT-SRV-ATTR:host"] 
    if instance["status"] == "ACTIVE" 
        num = num +1
    end
end

tenant_id="007589e7f70f406db10e3aabdae3c39f" 
computeHosts = Array.new(0) 

hosts=RestClient.get("http://localhost:8774/v2/#{tenant_id}/os-hosts", {'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json})
hosts=JSON.parse(hosts); 
hosts["hosts"].each do |host|
    puts host["service"] 
    if host["service"] == "compute" 
        puts host["host_name"] 
        computeHosts.push(host["host_name"])
    end
end

