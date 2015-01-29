angular.module('rspider')
.factory('API', function($http) {
  return {
    getDomains: function(callback) {
      $http.get('domains').success(function(data) {
        callback(data);
      })
    },
    getPages: function(params, callback) {
      $http.get('pages', {params: params})
      .success(function(data) {
        callback(data);
      })
    },
    retryPages: function(callback) {
      $http.post('pages/retry')
      .success(function(data) {
        callback(data);
      })
    },
    getStatistic: function(params, callback) {
      $http.get('pages/statistic', {params: params})
      .success(function(data) {
        var totalURLs = 0;
        var statistic = {};

        angular.forEach(data, function(record, index) {
          totalURLs += record.count;

          if(record.status == 0) {
            statistic.queued = record.count;
          } else if(record.status == 200) {
            statistic.cached = record.count;
          } else if(record.status == 404) {
            statistic.notFound = record.count;
          } else {
            statistic.failed = record.count;
          }
        });

        statistic.total = totalURLs

        callback(statistic);
      })
    }
  };
});
