require './config/environment'
use ActiveRecord::ConnectionAdapters::ConnectionManagement

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post]
  end
end

run Counter::API