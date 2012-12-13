require 'httparty'
require 'active_support/core_ext'
require  'json'

class Jmx

    include HTTParty
    base_uri "http://192.168.1.232:8899"
    format :json

    def initialize(items=[] ,options={})
      self.class.base_uri options[:base_uri] if options[:base_uri]
      @payload = Array.new
      @items = items
      @items.each do |item|  mbean,attribute,path = item.split(';')
        tokens = { "mbean" => mbean, "attribute" => attribute, "type" => "READ"}
        tokens["path"] = path if path
        @payload  << tokens
      end
    end

    # http://www.jolokia.org/reference/html/protocol.html#search

    def search(mbean,config={})
      self.class.post('/jolokia/', :body => { "type" => "SEARCH", "mbean" => mbean, "config" => config}.to_json)
      #self.class.post('/jolokia', :body => { "type" => "SEARCH", "mbean" => mbean, "config" => config}.to_json)
    end

    # http://www.jolokia.org/reference/html/protocol.html#list
    # use options = { "maxDepth" => 2} to limit depth

    def list(path,config={})
      self.class.post('/jolokia/', :body => {"type" => "LIST"}.to_json)
      #self.class.post('/jolokia/', :body => { "type" => "LIST", "path" => path, "config" => config}.to_json)
    end

    def read(mbean,attribute,path=nil,config={})
      payload = { "type" => "READ", "mbean" => mbean, "attribute" => attribute}
      payload["path"] = path if path
      payload["config"] = config if config.length > 0
      payload.to_json
      puts(payload.to_s)
      self.class.post('/jolokia/', :body => payload.to_json, :timeout => 5)
    end

    def exec(mbean,operation,arguments={})
      payload = { "type" => "EXEC", "mbean" => mbean, "operation" => operation}
      #payload["path"] = path if path
      payload["arguments"] = arguments if arguments.length > 0
      payload.to_json
      puts(payload)
      self.class.post('/jolokia/', :body => payload.to_json, :timeout => 5)
    end

    def version
      self.class.post('/jolokia/', :body => { "type" => "VERSION"}.to_json)
    end

    def processed_items
      data = self.class.post('/jolokia/', :body => @payload.to_json, :timeout => 5) rescue nil
      result = Hash.new
      data.each{|datum| result[result_key(datum)] = datum['value'] if datum['request']} if data
      result
    end

    private

    def result_key(datum)
      "#{self.class.to_s.demodulize.underscore}[#{datum['request']['mbean']};#{datum['request']['attribute']};#{datum['request']['path']}]"
    end
  end

#==================================================================
#create and instance for the Jolokia JMX requrests 

JTest2=Jmx.new
#JTest1=Jmx.new
#test the JMX calls for the Jolokia 

#puts (JTest1.version)

#puts(JTest2.search("Mule.jta*:*"))
puts(JTest2.list("",""))

#puts(JTest1.exec("java.lang:type=Threading","dumpAllThreads",["true","true"]))
#puts(JTest1.read("Catalina:J2EEApplication=none,J2EEServer=none,j2eeType=WebModule,name=//localhost/jolokia", "workDir"))

