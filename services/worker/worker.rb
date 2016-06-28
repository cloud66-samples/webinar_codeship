#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"
require "json"
require "logger"
require "restclient"

conn = conn = Bunny.new host: ENV['RABBITMQ_HOST'] || 'rabbitmq.cloud66.local', user: ENV['RABBITMQ_USERNAME'], pass: ENV['RABBITMQ_PASSWORD']
conn.start

ch   = conn.create_channel
work_queue = ch.queue("bakery.order", :durable => true)

ch.prefetch(1)
sleep_time = 1

logger = Logger.new(STDOUT)
logger.formatter = proc do |severity, datetime, progname, msg|
   "| #{msg}\n"
end

logger.info "--------------------------------"
logger.info "work minion v1.0 ready to rock!"
logger.info "--------------------------------"
logger.info "#{ENV['HOSTNAME']}:-- [*] Waiting for work orders (backing time = #{sleep_time})"

begin
    work_queue.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, payload|
    ch.ack(delivery_info.delivery_tag)
    
    # payload = {"flavour":"brown","order":"1"}
    task = JSON.parse payload
    flavour = task['flavour']
    kind = task['kind']
    order = task['order']

    logger.info "#{ENV['HOSTNAME']}:-- [.] Start backing a #{flavour} #{kind}"

    #the real backing start here
    sleep sleep_time

    logger.info "#{ENV['HOSTNAME']}:-- [x] Backing a #{flavour} #{kind} done"
    RestClient.post "http://api.cloud66.local/v1/orders/#{task['id']}/sweet/done", {}, :content_type => :json, :accept => :json
  end
rescue Interrupt => _
  conn.close
end