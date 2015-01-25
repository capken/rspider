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
    }
  };
});
