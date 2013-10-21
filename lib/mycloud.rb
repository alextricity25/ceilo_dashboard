require 'erb' 
require 'rest_client' 
require 'json'


class MyCloud

    attr_accessor :numOfInstances, :numOfComputeHosts, :instancesPerHost, :activeInstances, :hosts

    def initialize()
        @numOfInstances = 0
        @activeInstances = Array.new() 
        @numOfComputeHosts =0 
        @hosts = Array.new() 
	@hostsHash = Hash.new({value:0}) 
        @instancesPerHost = Hash.new({value: 0 }) 
        @token = ENV['TOKEN']
        @tenant_id="c19d3df0a19c4e1fbd1ba426eaea4ffb"
	@disk_space_availableGB = 0
    end

    def findActiveInstances
        allInstances = RestClient.get("http://localhost:8774/v2/#{@tenant_id}/servers/detail", {'X-Auth-Token' => "#{@token}", :content_type => :json, :accept => :json})
        allInstances = JSON.parse(allInstances)
	@activeInstances = Array.new() 
	@numOfInstances = 0
        allInstances["servers"].each do |instance|
            if instance["status"] == "ACTIVE"
                @activeInstances.push(instance)
                @numOfInstances = @numOfInstances + 1
            end
        end
    end

    #We can use this method to find the number of VMs/host AND the total number of VMs
    def findHosts
	hosts = RestClient.get("http://localhost:8774/v2/#{@tenant_id}/os-hosts", {'X-Auth-Token' => "#{@token}", :content_type => :json, :accept => :json})
	@hosts = JSON.parse(hosts)
	@hosts["hosts"].each do |host| 
	    if host["service"] == "compute"
	        num = 0 
	        @activeInstances.each do |instance|
		    if instance["OS-EXT-SRV-ATTR:host"] == host["host_name"]
		        num = num + 1
		    end 
	        end 
	        @hostsHash[host["host_name"]] = {label: host["host_name"], value:num}
	    end 
	end
	@hostsHash
    end 

    def getDiskSpaceAvail
	hypervisorStats = RestClient.get("http://localhost:8774/v2/#{@tenant_id}/os-hypervisors/statistics", {'X-Auth-Token' => "#{@token}", :content_type => :json, :accept => :json})
	hypervisorStats = JSON.parse(hypervisorStats)
	hypervisorStats = hypervisorStats["hypervisor_statistics"]
	@disk_space_availableGB = hypervisorStats["free_disk_gb"]
    end 
	



    def render(path) 
        content = File.read(File.expand_path(path))
        t = ERB.new(content) 
        t.result(binding)
    end

end


#Tests
#openstack = MyCloud.new() 
#puts openstack.getDiskSpaceAvail()
