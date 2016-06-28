class OrderService
  constructor: (@$resource, @config) ->
    @service = @$resource "#{@config.api}/v1/orders", {}, { query: { isArray: true } }

  fetch: (successHandler) ->
    @service.query().$promise.then (e) ->
      successHandler(e)

  place_order: (order, successHandler) ->
    @service.save(order).$promise.then (e) ->
      successHandler(e)


angular.module('demo').service 'orderService', ['$resource', 'config', OrderService]