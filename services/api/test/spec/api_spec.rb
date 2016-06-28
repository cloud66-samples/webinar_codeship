require 'spec_helper'
require 'restclient'

describe 'API' do
  it 'returns no orders when database is empty' do
    response = RestClient.post "http://api.cloud66.local/v1/orders", '{"amount": 1,"flavour": "cola","kind": "spacecake"}', :content_type => :json, :accept => :json
  	response_hash = JSON.parse(response)
  	expect(response_hash['amount']).to eq 1
  end
  it 'returns no orders when database is empty' do
    response = RestClient.get "http://api.cloud66.local/v1/orders", :content_type => :json, :accept => :json
  	response_hash = JSON.parse(response)
  	expect(response_hash).to eq []
  end
end