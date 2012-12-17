class ZabbixApi
  class Hosts

    def initialize(options = {})
      @client = Client.new(options)
      @options = options
      @host_default_options = {
        :host => nil,
        :available =>0,
        :status => 1,
        :proxy_hostid => 0,
        :groups => [],
        :useipmi => 0,
        :ipmi_ip => '',
        :ipmi_port => 623,
        :ipmi_authtype => 0,
        :ipmi_available => 0,
        :ipmi_privilege => 0,
        :ipmi_username => '',
        :ipmi_password => '',
        :jmx_available =>0,
        :name => nil,

      }
    end

    def merge_params(params)
      result = JSON.generate(@host_default_options).to_s + "," + JSON.generate(params).to_s
      JSON.parse(result.gsub('},{', ','))
    end

    def create(data)
      result = @client.api_request(:method => "host.create", :params => [merge_params(data)])
      result.empty? ? nil : result['hostids'][0].to_i
    end

    def add(data)
      create(data)
    end

    def unlink_templates(data)
      result = @client.api_request(
        :method => "host.massRemove", 
        :params => {
          :hostids => data[:hosts_id],
          :templates => data[:templates_id]
        }
      )
      case @client.api_version
        when "1.2"
          result ? true : false
        else
          result.empty? ? false : true
      end
    end

    def delete(data)
      result = @client.api_request(:method => "host.delete", :params => [:hostid => data])
      result.empty? ? nil : result['hostids'][0].to_i
    end

    def destroy(data)
      delete(data)
    end

    def update(data)
      result = @client.api_request(:method => "host.update", :params => data)
      result.empty? ? nil : result['hostids'][0].to_i
    end

    def get_full_data(data)
      @client.api_request(:method => "host.get", :params => {:filter => data, :output => "extend"})
    end

    def create_or_update(data)
      hostid = get_id(:host => data[:host])
      hostid ? update(data.merge(:hostid => hostid)) : create(data)
    end

    def get_id(data)
      result = get_full_data(data)
      hostid = nil
      result.each { |host| hostid = host['hostid'].to_i if host['host'] == data[:host] }
      hostid
    end

  end
end
