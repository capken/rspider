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
    getStatistic: function(params, callback) {
      $http.get('pages/statistic', {params: params})
      .success(function(data) {
        var totalURLs = 0;
        var countByStatus = [];

        angular.forEach(data, function(record, index) {
          totalURLs += record.count;
          var item = { count: record.count };

          switch (record.status) {
            case '000':
              item.type = 'info';
              break;
            case '200':
              item.type = 'success';
              break;
            default:
              item.type = 'danger';
          }

          countByStatus.push(item);
        });

        angular.forEach(countByStatus, function(item, index) {
          item.percentage = Math.round(item.count*1000/totalURLs)/10;
        });

        callback({
          "total": totalURLs,
          "details": countByStatus
        });
      })
    }
  };
});
