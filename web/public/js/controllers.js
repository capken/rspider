angular.module('rspider')
.controller('MainCtrl', function($scope) {
})
.controller('DomainCtrl', function($scope, API) {
  API.getDomains(function(domains) {
    $scope.domains = domains;
  });

})
.controller('PageCtrl', function($scope, $state, $stateParams, $location, API) {
  $scope.headers = ['URL', 'Created Time', 'Cached Time', 'Status'];
  $scope.domain = $stateParams.domain;

  $scope.pageChanged = function() {
    $location.search('pageNum', $scope.currentPage);
    updatePages($scope.currentPage);
  }

  var updatePages = function(pageNum) {
    API.getPages({
      domain: $scope.domain,
      p: pageNum
    }, function(data) {
      $scope.totalPages = data.total
      $scope.pages = data.pages;

      if($scope.currentPage !== pageNum) {
        $scope.currentPage = pageNum;
      }
    });
  };

  var updateStatistic = function() {
    API.getStatistic({
      domain: $scope.domain
    }, function(result) {
      console.log(JSON.stringify(result));
      $scope.totalURLs = result.total;
      $scope.stacked = result.details; 
    });
  };

  // start to render the web page
  updatePages($stateParams.pageNum);
  setInterval(updateStatistic, 2000);
});
