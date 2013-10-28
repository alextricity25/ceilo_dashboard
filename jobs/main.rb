require 'rest_client' 
require 'json' 
require_relative '../lib/mycloud'



openstack = MyCloud.new() 

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '2s', :first_in => 0 do |job|

  openstack.findActiveInstances(); 
  numOfInstances = openstack.numOfInstances
  hostsHash = openstack.findHosts() 
  diskSpaceAvail = openstack.getDiskSpaceAvail() 
  openstack.renderComputeHosts()

  #sending the data to the widgets
  send_event('numOfInstances', {current: numOfInstances, last: 0 })
  send_event('computeNodes', {items: hostsHash.values})
  send_event('freedisk', {current: diskSpaceAvail, last: 0})
end



