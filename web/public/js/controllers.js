angular.module('rspider')
.controller('MainCtrl', function($scope) {
})
.controller('DomainCtrl', function($scope, API) {
  API.getDomains(function(domains) {
    $scope.domains = domains;
  });

})
.controller('PageCtrl', function($scope, $state, $stateParams, API) {
  $scope.domain = $stateParams.domain;

  $scope.headers = ['URL', 'Created Time', 'Cached Time', 'Status'];

  $scope.pageChanged = function() {
    $state.go('pages', {
      domain: $scope.domain,
      pageNum: $scope.currentPage
    });
  }

  API.getPages({
    domain: $stateParams.domain,
    p: $stateParams.pageNum
  }, function(data) {
    $scope.currentPage = $stateParams.pageNum;
    $scope.totalPages = data.total
    $scope.pages = data.pages;
  });
});
