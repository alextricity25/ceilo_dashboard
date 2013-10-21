require 'rest_client' 
require 'json' 
require 'mysql2' 
token="MIIOrQYJKoZIhvcNAQcCoIIOnjCCDpoCAQExCTAHBgUrDgMCGjCCDQMGCSqGSIb3DQEHAaCCDPQEggzweyJhY2Nlc3MiOiB7InRva2VuIjogeyJpc3N1ZWRfYXQiOiAiMjAxMy0xMC0xNVQxNzoxMzozNS42NTI3ODAiLCAiZXhwaXJlcyI6ICIyMDEzLTEwLTE2VDE3OjEzOjM1WiIsICJpZCI6ICJwbGFjZWhvbGRlciIsICJ0ZW5hbnQiOiB7ImRlc2NyaXB0aW9uIjogIiIsICJlbmFibGVkIjogdHJ1ZSwgImlkIjogIjAwNzU4OWU3ZjcwZjQwNmRiMTBlM2FhYmRhZTNjMzlmIiwgIm5hbWUiOiAiYWRtaW4ifX0sICJzZXJ2aWNlQ2F0YWxvZyI6IFt7ImVuZHBvaW50cyI6IFt7ImFkbWluVVJMIjogImh0dHA6Ly8xNjYuNzguMTkwLjEwMzo4Nzc0L3YyLzAwNzU4OWU3ZjcwZjQwNmRiMTBlM2FhYmRhZTNjMzlmIiwgInJlZ2lvbiI6ICJSZWdpb25PbmUiLCAiaW50ZXJuYWxVUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjg3NzQvdjIvMDA3NTg5ZTdmNzBmNDA2ZGIxMGUzYWFiZGFlM2MzOWYiLCAiaWQiOiAiOTc1MWE3YzYxMjA1NGUyNWI5MTk1NGFhNWFmY2FkY2EiLCAicHVibGljVVJMIjogImh0dHA6Ly8xNjYuNzguMTkwLjEwMzo4Nzc0L3YyLzAwNzU4OWU3ZjcwZjQwNmRiMTBlM2FhYmRhZTNjMzlmIn1dLCAiZW5kcG9pbnRzX2xpbmtzIjogW10sICJ0eXBlIjogImNvbXB1dGUiLCAibmFtZSI6ICJub3ZhIn0sIHsiZW5kcG9pbnRzIjogW3siYWRtaW5VUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjg3NzYvdjIvMDA3NTg5ZTdmNzBmNDA2ZGIxMGUzYWFiZGFlM2MzOWYiLCAicmVnaW9uIjogIlJlZ2lvbk9uZSIsICJpbnRlcm5hbFVSTCI6ICJodHRwOi8vMTY2Ljc4LjE5MC4xMDM6ODc3Ni92Mi8wMDc1ODllN2Y3MGY0MDZkYjEwZTNhYWJkYWUzYzM5ZiIsICJpZCI6ICI1ZDJlNzIzOTE0MWQ0ZWUxODM4NmMzOWM3MTU1NmJhYyIsICJwdWJsaWNVUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjg3NzYvdjIvMDA3NTg5ZTdmNzBmNDA2ZGIxMGUzYWFiZGFlM2MzOWYifV0sICJlbmRwb2ludHNfbGlua3MiOiBbXSwgInR5cGUiOiAidm9sdW1ldjIiLCAibmFtZSI6ICJjaW5kZXIifSwgeyJlbmRwb2ludHMiOiBbeyJhZG1pblVSTCI6ICJodHRwOi8vMTY2Ljc4LjE5MC4xMDM6ODc3NC92MyIsICJyZWdpb24iOiAiUmVnaW9uT25lIiwgImludGVybmFsVVJMIjogImh0dHA6Ly8xNjYuNzguMTkwLjEwMzo4Nzc0L3YzIiwgImlkIjogIjFmNTg3MzIzNWRlZDQwYjQ5NTJkMjZmMzg4MTAyYjQxIiwgInB1YmxpY1VSTCI6ICJodHRwOi8vMTY2Ljc4LjE5MC4xMDM6ODc3NC92MyJ9XSwgImVuZHBvaW50c19saW5rcyI6IFtdLCAidHlwZSI6ICJjb21wdXRldjMiLCAibmFtZSI6ICJub3ZhIn0sIHsiZW5kcG9pbnRzIjogW3siYWRtaW5VUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjMzMzMiLCAicmVnaW9uIjogIlJlZ2lvbk9uZSIsICJpbnRlcm5hbFVSTCI6ICJodHRwOi8vMTY2Ljc4LjE5MC4xMDM6MzMzMyIsICJpZCI6ICI2OGZjNmY1NjliM2U0MDVjODZlOTAwNzZkZDYwNzIyMSIsICJwdWJsaWNVUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjMzMzMifV0sICJlbmRwb2ludHNfbGlua3MiOiBbXSwgInR5cGUiOiAiczMiLCAibmFtZSI6ICJzMyJ9LCB7ImVuZHBvaW50cyI6IFt7ImFkbWluVVJMIjogImh0dHA6Ly8xNjYuNzguMTkwLjEwMzo5MjkyIiwgInJlZ2lvbiI6ICJSZWdpb25PbmUiLCAiaW50ZXJuYWxVUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjkyOTIiLCAiaWQiOiAiMjM2ZTFmMzRmZjkyNGIyZjgzNDg2NWYwNmE0ZTA0MTEiLCAicHVibGljVVJMIjogImh0dHA6Ly8xNjYuNzguMTkwLjEwMzo5MjkyIn1dLCAiZW5kcG9pbnRzX2xpbmtzIjogW10sICJ0eXBlIjogImltYWdlIiwgIm5hbWUiOiAiZ2xhbmNlIn0sIHsiZW5kcG9pbnRzIjogW3siYWRtaW5VUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjg3NzciLCAicmVnaW9uIjogIlJlZ2lvbk9uZSIsICJpbnRlcm5hbFVSTCI6ICJodHRwOi8vMTY2Ljc4LjE5MC4xMDM6ODc3NyIsICJpZCI6ICIyMjhmZDg3NmNhY2Q0MmRkYmFmNWU3NWI0NTBhNGExYiIsICJwdWJsaWNVUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjg3NzcifV0sICJlbmRwb2ludHNfbGlua3MiOiBbXSwgInR5cGUiOiAibWV0ZXJpbmciLCAibmFtZSI6ICJjZWlsb21ldGVyIn0sIHsiZW5kcG9pbnRzIjogW3siYWRtaW5VUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjg3NzYvdjEvMDA3NTg5ZTdmNzBmNDA2ZGIxMGUzYWFiZGFlM2MzOWYiLCAicmVnaW9uIjogIlJlZ2lvbk9uZSIsICJpbnRlcm5hbFVSTCI6ICJodHRwOi8vMTY2Ljc4LjE5MC4xMDM6ODc3Ni92MS8wMDc1ODllN2Y3MGY0MDZkYjEwZTNhYWJkYWUzYzM5ZiIsICJpZCI6ICIyMTRkMGVhNzVkMTU0MGM5OThkNDAwMDQ5OTQ1NzFkZCIsICJwdWJsaWNVUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjg3NzYvdjEvMDA3NTg5ZTdmNzBmNDA2ZGIxMGUzYWFiZGFlM2MzOWYifV0sICJlbmRwb2ludHNfbGlua3MiOiBbXSwgInR5cGUiOiAidm9sdW1lIiwgIm5hbWUiOiAiY2luZGVyIn0sIHsiZW5kcG9pbnRzIjogW3siYWRtaW5VUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjg3NzMvc2VydmljZXMvQWRtaW4iLCAicmVnaW9uIjogIlJlZ2lvbk9uZSIsICJpbnRlcm5hbFVSTCI6ICJodHRwOi8vMTY2Ljc4LjE5MC4xMDM6ODc3My9zZXJ2aWNlcy9DbG91ZCIsICJpZCI6ICIxMTE5OGMzZWZmNmE0NjliYjEwOWFkZWEzNjI5OWY0NyIsICJwdWJsaWNVUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjg3NzMvc2VydmljZXMvQ2xvdWQifV0sICJlbmRwb2ludHNfbGlua3MiOiBbXSwgInR5cGUiOiAiZWMyIiwgIm5hbWUiOiAiZWMyIn0sIHsiZW5kcG9pbnRzIjogW3siYWRtaW5VUkwiOiAiaHR0cDovLzE2Ni43OC4xOTAuMTAzOjM1MzU3L3YyLjAiLCAicmVnaW9uIjogIlJlZ2lvbk9uZSIsICJpbnRlcm5hbFVSTCI6ICJodHRwOi8vMTY2Ljc4LjE5MC4xMDM6NTAwMC92Mi4wIiwgImlkIjogIjZjODc4NjdmOGQyZjQyNzZiODM4MWE2ZGNjY2RmODA0IiwgInB1YmxpY1VSTCI6ICJodHRwOi8vMTY2Ljc4LjE5MC4xMDM6NTAwMC92Mi4wIn1dLCAiZW5kcG9pbnRzX2xpbmtzIjogW10sICJ0eXBlIjogImlkZW50aXR5IiwgIm5hbWUiOiAia2V5c3RvbmUifV0sICJ1c2VyIjogeyJ1c2VybmFtZSI6ICJhZG1pbiIsICJyb2xlc19saW5rcyI6IFtdLCAiaWQiOiAiMmZjNDA1ODZhYzk5NGU5N2E3OTQzMTAzOTExMDQxYTQiLCAicm9sZXMiOiBbeyJuYW1lIjogImFkbWluIn1dLCAibmFtZSI6ICJhZG1pbiJ9LCAibWV0YWRhdGEiOiB7ImlzX2FkbWluIjogMCwgInJvbGVzIjogWyJmZGY4ZWNmNzdkMDM0NjliOTA4YWRjYmNhMmM4YTg5MSJdfX19MYIBgTCCAX0CAQEwXDBXMQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVW5zZXQxDjAMBgNVBAcMBVVuc2V0MQ4wDAYDVQQKDAVVbnNldDEYMBYGA1UEAwwPd3d3LmV4YW1wbGUuY29tAgEBMAcGBSsOAwIaMA0GCSqGSIb3DQEBAQUABIIBADjz85jsIbWbVYscD7OaYUlk3ADc+N1Evvg6duMdp21sULxzM4QL5nr7xYnWoU4T2SxjGRewwnPM2NAxUIJXaThmKrwnM5vV4b5VTp-E2+ZsinU+FOvgH8u5CmiUucEtCQyr1WajsEz4Yyj2eyLDTsGqg5jYdFrBZMaGAlNwaUVcx1RWEvudUkUq+L3F5X45I2U5myZfLAtN35EZ9RUAIKToZSfUGskA1D3TACZm-54m7GJdS+GxnCDAXbGGQDNfIYP50ZrjM7O8pfpm6BHwVcHrV2fMh-FmOnyZgzdfYXFWvQdA2WSUB9PiWFWuUGhZDrUsUcmRIto8mNppxV7WIxs="

#client = Mysql2::Client.new(:host => "localhost",:username => "root", :password => "password", :database => "nova") 




SCHEDULER.every '10s' do

	#Getting the number of active instances from the nova API 
#	
#	numOfInstances = RestClient.get("http://166.78.190.103:8774/v2/007589e7f70f406db10e3aabdae3c39f/servers/detail", {'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json})
#	numOfInstances = JSON.parse(numOfInstances) 
#
#	
#
#  response1= RestClient.get("http://localhost:8777/v2/meters/cpu_util/statistics", { 'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })
#
#  disk_read = RestClient.get("http://localhost:8777/v2/meters/disk.read.bytes/statistics", { 'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })
#  disk_read = JSON.parse(disk_read) 
#
#  disk_write = RestClient.get("http://localhost:8777/v2/meters/disk.write.bytes/statistics", {'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })
#  disk_write = JSON.parse(disk_write) 
#
#  netinc = RestClient.get("http://localhost:8777/v2/meters/network.incoming.bytes/statistics", { 'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })
#  netinc = JSON.parse(netinc) 
#
#  #request statistics data from the network.outgoing.bytes meter from the ceilometer API 
#  netout = RestClient.get("http://localhost:8777/v2/meters/network.outgoing.bytes/statistics", { 'X-Auth-Token' => "#{token}", :content_type => :json, :accept => :json })
#  netout = JSON.parse(netout) 
#
		
  

  result = JSON.parse(response1) 
  current_avgcpu = result[0]['avg'].to_f
  current_avgcpu = current_avgcpu.round(2)
  current_diskread = disk_read[0]['avg'] 
  current_diskwrite =disk_write[0]['avg'] 
  current_netinc = netinc[0]['sum'] 
  current_netout = netout[0]['sum'] 
	current_numOfInstances = numOfInstances.length

  #send_event('valuation', { current: current_valuation, last: last_valuation })
  #send_event('karma', { current: current_karma, last: last_karma })
#  send_event('avgcpu', { current: current_avgcpu, last: 0})
#  send_event('diskread', {current: current_diskread, last: 0})
#  send_event('diskwrite', {current: current_diskwrite, last: 0})
#  send_event('netinc', {current: current_netinc, last: 0}) 
#  send_event('netout', {current: current_netout, last: 0}) 
end
