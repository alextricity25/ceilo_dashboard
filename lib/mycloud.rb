require 'erb' 
require 'rest_client' 
require 'json'


class MyCloud

    attr_accessor :numOfInstances, :numOfComputeHosts, :instancesPerHost, :activeInstances, :hosts

    def initialize()
        @token = ENV['TOKEN']
        @tenant_id="c19d3df0a19c4e1fbd1ba426eaea4ffb"
	@@num = 0 
        @numOfInstances = 0
        @activeInstances = Array.new() 
        @numOfComputeHosts =0 
        #@hosts = Hash.new()
	hosts = RestClient.get("http://localhost:8774/v2/#{@tenant_id}/os-hosts", {'X-Auth-Token' => "#{@token}", :content_type => :json, :accept => :json})
	@hosts = JSON.parse(hosts)
	@hostsHash = Hash.new({value:0}) 
        @instancesPerHost = Hash.new({value: 0 }) 
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
		@@num = @@num +1
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
   
    def self.num 
	@@num 
    end
	



    def render(path) 
        content = File.read(File.expand_path(path))
        t = ERB.new(content) 
        t.result(binding)
    end

    def renderComputeHosts
	erb = ERB.new(File.read(File.expand_path(File.join(File.dirname(__FILE__), "/templates/compute.erb"))))
        # This outputs the erb code needed for the compute dashboard. 
	#puts erb.result(binding)
	#For each host, create a dashboard using the compute dashboard
#	@hosts["hosts"].each do |host|
#            path = File.expand_path("../dashboards", File.dirname(__FILE__))
#	    file = File.open("#{path}/#{host}.erb", 'w') 
#	    file.write(erb.result(binding))
#	end 
	@hostsHash.values.each do |host| 
	    puts host[:label]
	    path = File.expand_path("../dashboards", File.dirname(__FILE__))
	    if  !(File.exists?("#{path}/#{host[:lable]}.erb")) 
	    	file = File.open("#{path}/#{host[:label]}.erb", 'w')
	    	file.write(erb.result(binding))
	    	file.close
	    end
	end 
    end

end


#Tests
openstack = MyCloud.new() 
#puts openstack.getDiskSpaceAvail()
openstack.renderComputeHosts()


