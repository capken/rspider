angular.module('rspider')
.controller('MainCtrl', function($scope) {
})
.controller('DomainCtrl', function($scope, API) {
  API.getDomains(function(domains) {
    $scope.domains = domains;
  });

})
.controller('PageCtrl', function($scope, $state, $stateParams, $location, API) {
  $scope.headers = ['URL', 'Created Time', 'Cached Time', 'Status', 'Actions'];
  $scope.domain = $stateParams.domain;

  $scope.pageChanged = function() {
    $location.search('pageNum', $scope.currentPage);
    $location.search('status', $scope.selectedPageStatus);
    updatePages($scope.selectedPageStatus, $scope.currentPage);
  }

  $scope.$watch('selectedPageStatus', function(newValue, oldValue) {
    console.log(newValue);
    if(angular.isDefined(newValue) && 
      angular.isDefined(oldValue) && newValue !== oldValue) {
      $location.search('pageNum', 1);
      $location.search('status', newValue);
      updatePages(newValue, 1);
    }
  });

  var updatePages = function(pageStatus, pageNum) {
    API.getPages({
      domain: $scope.domain,
      status: pageStatus,
      p: pageNum
    }, function(data) {
      $scope.totalPages = data.total
      $scope.pages = data.pages;

      if($scope.currentPage !== pageNum) {
        $scope.currentPage = pageNum;
      }

      if($scope.selectedPageStatus !== pageStatus) {
        $scope.selectedPageStatus = pageStatus;
      }
    });
  };

  var updateStatistic = function() {
    API.getStatistic({
      domain: $scope.domain
    }, function(statistic) {
      console.log(JSON.stringify(statistic));
      $scope.statistic = statistic; 
    });
  };

  updatePages($stateParams.status, $stateParams.pageNum);

  updateStatistic();
  //setInterval(updateStatistic, 2000);
});
