// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .

$(document).ready(function(){


    $(".artist-view").hide();
    $(".error-view").hide();
    $(".load-view").hide();
    $(".no-result-view").hide();

    $(".backup_picture").error(function(){
        $(this).attr('src', 'http://i61.tinypic.com/2mwdtsk.png');
    });

});

angular.module("myApp", []).controller("MyController", function($scope, $http) {

    $scope.historyData = {};
    $scope.artistData = {};
    $scope.moreData = {};

    $scope.init = function () {

        $scope.cpage = 0;
        var response = $http.get("/history/get?cpage="+$scope.cpage);

        response.success(function(data, status, headers, config) {

            if( data.cpage === "nopageleft")
            {
                $("#more_button").hide();
            }
            else
            {
                $scope.historyData = data.history;
                $scope.cpage = $scope.cpage+1;
                $(".more_button").show();
            }

        });

        response.error(function(data, status, headers, config) {

        });
    }






    $scope.artistData.doClick = function(item, event) {


        if(!$("#search-artist").val().match(/^\s*$/) ) {

            $(".history-view").hide();
            $(".load-view").show();
            $scope.cpage = 0;
            var response = $http.get("/search/artist?search_string=" + $("#search-artist").val());

            response.success(function (data, status, headers, config) {

                if (data.error || jQuery.isEmptyObject(data)) {
                    //hide activate loading
                    $(".load-view").hide();
                    //show artist content
                    $(".no-result-view").show();

                }
                else {
                    $('#search-artist').val("");
                    $scope.artistData.name = data.name;
                    $scope.artistData.image = data.image;
                    $scope.artistData.url = data.url;
                    $scope.artistData.similar_artist = data.similar_artist;
                    $scope.artistData.tags = data.tags;
                    $scope.artistData.albums = data.albums;

                    //hide activate loading
                    $(".load-view").hide();
                    //show artist content
                    $(".artist-view").show();

                }
                $('#search-artist').val("");
            });

            response.error(function (data, status, headers, config) {
                $('#search-artist').val("");
                //hide activate loading
                $(".load-view").hide();
                //show artist content
                $(".error-view").show();
            });

        }

    }

    $scope.moreData.g = function(item , event){

        var response = $http.get("/history/get?cpage="+$scope.cpage);

        response.success(function(data, status, headers, config) {
            if( data.cpage === "nopageleft")
            {
                $("#more_button").hide();
            }
            else
            {

                $scope.historyData = $.merge($scope.historyData,data.history);// data.history;
                $scope.cpage = $scope.cpage+1;
                $("#more_button").show();

            }

        });

        response.error(function(data, status, headers, config) {

        });
    }


} );