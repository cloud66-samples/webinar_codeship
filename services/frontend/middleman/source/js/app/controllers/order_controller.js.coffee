class OrderController
  constructor: (@$sce, @$scope, @orderService, @timeout) ->
    @all()

  all: () ->
  	@orderService.fetch (data) =>
      @$scope.orders = data.reverse()
    
    @timeout (=>
      @all()
    ), 1000

  orderstuff: () ->
    @orderService.place_order @$scope.order, (data) =>
      @all()

angular.module('demo').controller 'orderController',
  ['$sce', '$scope', 'orderService', '$timeout', OrderController]  