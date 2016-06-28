require 'rack/contrib'

module Counter
  class API < Grape::API
    version 'v1'
    format :json
  

    queue = MessageQueue.new

    get 'health' do
      if queue.open?
        {health: 'ok', server: ENV['HOSTNAME']}
      else
        {health: 'nok', server: ENV['HOSTNAME']}
      end
    end

    # GET http://xxx/v1/orders     - curl -X GET -H "Content-type: application/json" -H "Accept: application/json" http://192.168.99.100:8000/v1/orders
    # GET http://xxx/v1/orders/1    - curl -X GET -H "Content-type: application/json" -H "Accept: application/json" http://192.168.99.100:8000/v1/orders/1
    # POST http://xxx/v1/orders/1   - curl -X POST --data '{"amount": 1,"flavour": "cola","kind": "spacecake"}' -H "Content-type: application/json" -H "Accept: application/json" http://192.168.99.100:8000/v1/orders
    # POST http://xxx/v1/orders/1/sweet/done  - curl -X POST  -H "Accept: application/json" http://192.168.99.100:8000/v1/orders/1/sweet/done 
      

    resource :orders do

      desc 'Return all orders.'
      get do
        Order.all
      end


      desc 'Return a order.'
      params do
        requires :id, type: Integer, desc: 'Order id.'
      end
      route_param :id do
        get do
          Order.find(params[:id])
        end
        post 'sweet/done' do
          Order.transaction do
            order = Order.lock.find(params[:id])
            order.one_sweet_done()
          end
          {sweet_registered: 'ok'}
        end
      end

      desc 'Create a order.'
      params do
        requires :kind, type: String, desc: 'The sweet goods', values: ['spacecake', 'bagel', 'donut']
        requires :flavour, type: String, desc: 'Your favorite sweet flavour', values: ['stawberry', 'cola', 'glitter', 'rum']
        requires :amount, type: Integer, desc: 'Amount of sweet stuff.'
      end
      post do
        order = Order.create!({
          kind: params[:kind],
          flavour: params[:flavour],
          amount: params[:amount]
        })
        payload = order.to_json
        if queue.open?
          Integer(params[:amount]).times do
            queue.publish payload
          end
        end
        order
      end
    end

  end
end