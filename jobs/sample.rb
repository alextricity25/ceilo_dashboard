require 'rest_client' 
require 'json' 


current_valuation = 0
current_karma = 0
token="<your token>" 


SCHEDULER.every '4s' do
  last_valuation = current_valuation
  last_karma     = current_karma
  current_valuation = rand(100)
  current_karma     = rand(200000)
  response1= RestClient.get("http://localhost:8777/v2/meters/cpu_util/statistics", { 'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })

  disk_read = RestClient.get("http://localhost:8777/v2/meters/disk.read.bytes/statistics", { 'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })
  disk_read = JSON.parse(disk_read) 

  disk_write = RestClient.get("http://localhost:8777/v2/meters/disk.write.bytes/statistics", {'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })
  disk_write = JSON.parse(disk_write) 

  netinc = RestClient.get("http://localhost:8777/v2/meters/network.incoming.bytes/statistics", { 'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })
  netinc = JSON.parse(netinc) 

  #request statistics data from the network.outgoing.bytes meter from the ceilometer API 
  netout = RestClient.get("http://localhost:8777/v2/meters/network.outgoing.bytes/statistics", { 'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })
  netout = JSON.parse(netout) 
  

  result = JSON.parse(response1) 
  current_avgcpu = result[0]['avg'].to_f
  current_avgcpu = current_avgcpu.round(2)
  current_diskread = disk_read[0]['avg'] 
  current_diskwrite =disk_write[0]['avg'] 
  current_netinc = netinc[0]['sum'] 
  current_netout = netout[0]['sum'] 

  #send_event('valuation', { current: current_valuation, last: last_valuation })
  #send_event('karma', { current: current_karma, last: last_karma })
  send_event('avgcpu', { current: current_avgcpu, last: 0})
  send_event('diskread', {current: current_diskread, last: 0})
  send_event('diskwrite', {current: current_diskwrite, last: 0})
  send_event('netinc', {current: current_netinc, last: 0}) 
  send_event('netout', {current: current_netout, last: 0}) 
end
