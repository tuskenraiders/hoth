require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Hoth::Endpoint do
  
  it "should have a port" do
    endpoint = Hoth::Endpoint.new(:port => 3000)
    endpoint.port.should == 3000
  end
  
  it "should have a host name" do
    endpoint = Hoth::Endpoint.new(:host => "example.com")
    endpoint.host.should == "example.com"
  end
  
  it "should have a transport type" do
    endpoint = Hoth::Endpoint.new(:transport_type => :json)
    endpoint.transport_type.should == :json
  end
  
  it "should should cast itself to URL string" do
    endpoint = Hoth::Endpoint.new(:port => 3000, :host => "example.com")
    endpoint.to_url.should == "http://example.com:3000/execute"
  end
  
  it "should compare to another endpoint" do
    json_endpoint = Hoth::Endpoint.new(
      :port => 3000,
      :host => "example.com",
      :transport_type => :json
    )

    bert_endpoint = Hoth::Endpoint.new(
      :port => 3000,
      :host => "example.com",
      :transport_type => :bert
    )
    
    json_endpoint.should equal(json_endpoint)
    json_endpoint.should_not equal(bert_endpoint)
  end
  
  it "should know if it is local or not" do
    endpoint = Hoth::Endpoint.new({})
    endpoint.is_local?.should_not be(nil)
  end
  
end