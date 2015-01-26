'use strict';

angular.module('rspider', ['ui.router', 'ui.bootstrap'])

.config(['$stateProvider', '$urlRouterProvider', 
  function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/domains');

    $stateProvider.state('domains', {
      url: '/domains',
      templateUrl: 'views/domains.html',
      controller: 'DomainCtrl'
    });

    $stateProvider.state('pages', {
      url: '/pages/:domain?{pageNum:int}&{status:string}',
      templateUrl: 'views/pages.html',
      controller: 'PageCtrl',
      reloadOnSearch: false
    });
  }
]);
