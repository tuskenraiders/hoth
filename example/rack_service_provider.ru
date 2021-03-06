ENV['RAILS_ENV'] ||= 'test'

$:.unshift(File.join("..", "lib"))

require 'rubygems'
require 'hoth'
require 'hoth/providers/rack_provider'
require 'deployment_definition'
require 'service_definition'
require 'business_objects'
require 'rack'

class IncrementStatisticsImpl
  def self.execute(statistic_objects, event)
    puts "** EXECUTING IncrementStatisticsImpl"
    puts "   statistic_objects: #{statistic_objects.inspect}"
    puts "   events: #{event.inspect}"
  end
end

class StatisticOfCarsImpl
  def self.execute(ids)
    puts "** EXECUTING StatisticOfCarsImpl"
    puts "   ids: #{ids.inspect}"
    
    return ids.inject([]) do |data, id|
      data << StatisticData.new(
        :events       => [Event.new(:name => "viewed", :count => rand(666))],
        :original_id => id
      )
    end
  end
end

app = lambda {|env| [200, {'Content-Type' => 'application/json'}, '{"hello":"world"}']}

Thread.abort_on_exception = true
rack_thread = Thread.new { run Hoth::Providers::RackProvider.new(app) }

Hoth::Services.increment_statistics "foo", "bar"

rack_thread.join
