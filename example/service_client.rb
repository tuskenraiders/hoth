$:.unshift(File.join("..", "lib"))

require 'rubygems'

require 'hoth'
require 'deployment_definition'
require 'service_definition'
require 'business_objects'

statistic_object = StatisticsObject.new(
  :id              => 23,
  :owner_id        => 42,
  :statistic_type  => "Car",
  :timestamp       => Time.now,
  :group_condition => nil
)

event = Event.new(:name => "viewed", :count => 2)

Hoth::Services.increment_statistics([statistic_object], event)

puts Hoth::Services.statistic_of_cars([23, 42, 303, 101]).inspect
