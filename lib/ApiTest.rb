require "zabbixapi"
#module "JTA-jolokia"


#connecto to the Zabbix server
zbx = ZabbixApi.connect(:url => 'http://zabbix2/zabbix/api_jsonrpc.php',:user => 'Admin', :password => 'zabbix')

#create a host 
#host_id = zbx.hosts.add(
#	:host => "testAPIHOST", 
#	:interfaces => [
#		:type => 1, 
#		:main => 1, 
#		:useip => 1, 
#		:ip => "192.168.1.231", 
#		:dns =>"", 
#		:port => 10050], 
#	:groups => [:groupid => zbx.hostgroups.get_id(:name => "Linux servers")])
#puts host_id
host_jmx_id = zbx.hosts.add(
	:host => "JasperJTA2", 
	:interfaces => [
	:type => 4, 
	:main => 1, 
	:useip => 1, 
	:ip => "127.0.0.1", 
	:dns =>"", 
	:port => 1098], 
	:groups => [:groupid => zbx.hostgroups.get_id(:name => "Linux servers")])

puts host_jmx_id

#enable the host 
#to enable monitoring the host we need to set the "status" flag to 0
zbx.hosts.update(:hostid => zbx.hosts.get_id(:host => "JasperJTA1"), :status =>0)

#delete  
#create an application
#zbx.applications.create(:name => "testApplication", :hostid => "10091")

#delete an item 


#create an item


#delete an item  