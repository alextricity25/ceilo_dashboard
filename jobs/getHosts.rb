require 'rest_client' 
require 'json' 

token=ENV['TOKEN']

tenant_id="007589e7f70f406db10e3aabdae3c39f"

#This hash will contain all the compute nodes, plus the number of active VMs they have running. 
computeHash = Hash.new({ value: 0 }) 

SCHEDULER.every '15s' do 

    #Getting information about the hosts
    hosts=RestClient.get("http://localhost:8774/v2/#{tenant_id}/os-hosts", {'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json})
    hosts=JSON.parse(hosts); 
    allInstances = RestClient.get("http://localhost:8774/v2/#{tenant_id}/servers/detail", {'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json})
    allInstances = JSON.parse(allInstances) 
    activeInstances = Array.new(0) 

    #Picking out all the Active instances 
    allInstances["servers"].each do |instance|
        if instance["status"] == "ACTIVE"
            activeInstances.push(instance)
        end
    end

    #Getting the number of VMs per host
    hosts["hosts"].each do |host|
        if host["service"] == "compute" 
            num = 0
            activeInstances.each do |instance| 
                puts "Host of Instance: #{instance["OS-EXT-SRV-ATTR:host"]}"
                if instance["OS-EXT-SRV-ATTR:host"] == host["host_name"] 
                    puts "yes!"
                    num = num + 1;
                end
            end
            computeHash[host["host_name"]] = {label: host["host_name"], value: num}
        end
    end


    send_event('computeNodes', {items: computeHash.values}) 



end
