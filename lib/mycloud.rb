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
        @instancesPerHost = Hash.new({value: 0 }) 
        @token = ENV['TOKEN']
        @tenant_id="007589e7f70f406db10e3aabdae3c39f"
    end

    def findActiveInstances
        allInstances = RestClient.get("http://localhost:8774/v2/#{@tenant_id}/servers/detail", {'X-Auth-Token' => "#{@token}", :content_type => :json, :accept => :json})
        allInstances = JSON.parse(allInstances)
        allInstances["servers"].each do |instance|
            if instance["status"] == "ACTIVE"
                @activeInstances.push(instance)
                @numOfInstances = @numOfInstances + 1
            end
        end
    end



    def render(path) 
        content = File.read(File.expand_path(path))
        t = ERB.new(content) 
        t.result(binding)
    end

end


#Tests
openstack = MyCloud.new() 
openstack.findActiveInstances 
