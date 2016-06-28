require 'spec_helper'
require 'bunny'

describe 'WORKER' do
  before do
    stub_request(:post, "http://api.cloud66.local/v1/orders/1/sweet/done")        
    @worker = Worker.new
    message_queue_connection =conn = Bunny.new host: ENV['RABBITMQ_HOST'] || 'rabbitmq.cloud66.local', user: ENV['RABBITMQ_USERNAME'], pass: ENV['RABBITMQ_PASSWORD']
    message_queue_connection.start()
    message_queue_channel = message_queue_connection.create_channel
    message_queue = message_queue_channel.queue("bakery.order", :durable => true)
    message = '{"id":"1","kind":"bagel", "flavour":"brown","order":"1"}'
    message_queue.publish message, persistent: true
  end

  it 'will make a request to the api' do
    @worker.start_workload(false)
    sleep 2
    expect(WebMock).to have_requested(:post, "http://api.cloud66.local/v1/orders/1/sweet/done").with(body: "").once
  end

end