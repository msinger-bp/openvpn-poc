#!/usr/bin/env ruby

require 'optparse'
require 'redis'

options = {
  critical: 100000,
  warning: 50000,
  hostname: '10.0.15.100',
}

OptionParser.new do |opts|
  opts.banner = "Usage: check_resque_queue.rb [options]"

  opts.on("-h", "--hostname QUEUE", "Hostname of Redis server") do |h|
    options[:hostname] = h
  end

  opts.on("-q", "--queue QUEUE", "Queue to check") do |q|
    options[:queue] = q
  end

  opts.on("-w", "--warning THRESHOLD", "Warning threshold value") do |w|
    options[:warning] = w.to_i
  end

  opts.on("-c", "--critical THRESHOLD", "Critical threshold value") do |c|
    options[:critical] = c.to_i
  end
end.parse!

r = Redis.new(host: options[:hostname], port: 6379)

queue_size = r.llen("resque:queue:#{options[:queue]}")

if queue_size > options[:critical]
  puts "CRITICAL - Queue size of #{options[:queue]} (#{queue_size}) is greater than the critical threshold of #{options[:critical]}"
  exit 2
elsif queue_size > options[:warning]
  puts "WARNING - Queue size of #{options[:queue]} (#{queue_size}) is greater than the warning threshold of #{options[:warning]}"
  exit 1
else
  puts "OK - Queue #{options[:queue]} is #{queue_size}"
  exit 0
end

