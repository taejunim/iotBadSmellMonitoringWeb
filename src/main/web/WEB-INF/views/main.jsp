<!--
Created by IntelliJ IDEA.
User: 조유영
Date: 2021/05/27
Time: 9:49 오전
메인
-->
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<style>
    .label {margin-bottom: 96px;}
    .label * {display: inline-block;vertical-align: top;}
    .label .left {background: url("https://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_l.png") no-repeat;display: inline-block;height: 24px;overflow: hidden;vertical-align: top;width: 7px;}
    .label .center {background: url(https://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_bg.png) repeat-x;display: inline-block;height: 24px;font-size: 12px;line-height: 24px;}
    .label .right {background: url("https://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_r.png") -1px 0  no-repeat;display: inline-block;height: 24px;overflow: hidden;width: 6px;}
</style>
<script src="/resources/js/kakaoMapUtils.js"></script>
<script type="text/javascript">
  var beforeLevel = 9;
  var map;
  var markers = [];
  var infoWindows = [];

  var customOverlayArray = [];
  var clusterers = [];
  var selectedCodeId = "";
  var selectedGpsX;
  var selectedGpsY;

  var isLoading = false;

  $(document).ready(function () {
    setButton("main");
    setDatePicker();                        //달력 SETTING CALL.
    $(".weatherStatus").css("display","none");

    //지도 기본 설정 -> 한라산 중심 잡아둠, Zoom Level 9
    var latitude  = 33.3617168;
    var longitude = 126.5204023;
    map = focusMapCenter(latitude, longitude, 9);

    fnSearch()
    /*$.ajax({
      url: "/pcMainListSelectAll",
      type: "GET",
      dataType: "json",
      success: function (data) {
        drawMarker(data);
        for(var i=0; i< markers.length ; i++){
          markers[i].setMap(map);
        }
        map.panTo( new kakao.maps.LatLng(latitude, longitude));
        map.setMaxLevel(13); // map의 레벨을 조정해서 맵이 깨지는 현상을 방지한다.
        // 클러스터러에 마커들을 추가합니다
        // clusterer.addMarkers(markers);
      },
      error: function (err) {
        alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
      }
    });*/

    //마커 위 infoWindow에도 이벤트 연결
    $(document).on("click",".infoWindow",function(event){
      clickMarker(event.target.id);
    });




    // 마커 클러스터러를 생성합니다
    var clusterer = new kakao.maps.MarkerClusterer({
        map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
        averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
        minLevel: 3, // 클러스터 할 최소 지도 레벨
        minClusterSize : 1,
        calculator: [10, 50, 100, 150, 200],
        gridSize : 80
    });

    // 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
    var zoomControl = new kakao.maps.ZoomControl();
    map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);



    /*kakao.maps.event.addListener(map, 'zoom_changed', function() {

        var afterLevel = map.getLevel();

        console.log("afterLevel : " + afterLevel);
        console.log("beforeLevel : " + beforeLevel);

        if (afterLevel > beforeLevel || afterLevel == 8) {
            closeInfoWindows();
        }

        beforeLevel = afterLevel;

    });*/

      kakao.maps.event.addListener(map, 'zoom_start', function() {

          if (isLoading) {
              kakao.maps.event.preventMap();
          }
      });

      kakao.maps.event.addListener(map, 'zoom_changed', function() {

          if (isLoading) {
              kakao.maps.event.preventMap();
              return;
          }
          isLoading = true;

          console.log("level : " + map.getLevel());

              if (selectedCodeId != null && selectedCodeId != "") {
                  if(map.getLevel() <= 9 && map.getLevel() >= 7) {
                      for (var i = 0 ; i < markers.length ; i++) {
                          markers[i].setMap(null);
                      }
                      for (var i = 0 ; i < clusterers.length ; i++) {
                          clusterers[i].clear();
                      }
                      for (var i = 0 ; i < customOverlayArray.length ; i++) {
                          customOverlayArray[i].setMap(null);
                          // customOverlayArray = [];
                      }

                      markers = [];
                      clusterers = [];
                      customOverlayArray = [];

                      fnSearch();
                  }
                  else if (map.getLevel() <= 6 && map.getLevel() >= 3){
                      console.log("66666666")
                      for (var i = 0 ; i < markers.length ; i++) {
                          markers[i].setMap(null);
                      }
                      for (var i = 0 ; i < clusterers.length ; i++) {
                          clusterers[i].clear();
                      }
                      for (var i = 0 ; i < customOverlayArray.length ; i++) {
                          customOverlayArray[i].setMap(null);
                          //customOverlayArray = [];
                      }

                      // 마커 클러스터러를 생성합니다
                      var clusterer = new kakao.maps.MarkerClusterer({
                          map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
                          averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
                          minLevel: 3, // 클러스터 할 최소 지도 레벨
                          minClusterSize : 1,
                          calculator: [10, 50, 100, 150, 200],
                          gridSize : 150
                      });

                      markers = [];
                      clusterers = [];
                      customOverlayArray = [];

                      console.log("selectedCodeId : " + selectedCodeId);
                      $.ajax({
                          url: "/pcMainListFindByMember",
                          type: "GET",
                          dataType: "json",
                          data : {
                              userRegionDetail :  selectedCodeId,
                              startDate : startDate,
                              endDate : endDate,
                              smellType : smellType,
                              smellValue : smellValue
                          },
                          success: function (data) {

                              drawMarker(data);
                              for(var i=0; i< markers.length ; i++){
                                  markers[i].setMap(map);
                              }
                              // 클러스터러에 마커들을 추가합니다
                              clusterer.addMarkers(markers);

                              clusterers.push(clusterer);

                              console.log("끝 : " + new Date().toTimeString().split(' ')[0])

                              isLoading = false;
                          },
                          error: function (err) {
                              alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
                          }
                      });
                  } else if (map.getLevel() <= 2){
                      for (var i = 0 ; i < markers.length ; i++) {
                          markers[i].setMap(null);
                      }
                      for (var i = 0 ; i < clusterers.length ; i++) {
                          clusterers[i].clear();
                      }
                      for (var i = 0 ; i < customOverlayArray.length ; i++) {
                          customOverlayArray[i].setMap(null);
                          // customOverlayArray = [];
                      }

                      clusterers = [];
                      customOverlayArray = [];

                      $.ajax({
                          url: "/pcMainListSelect",
                          type: "GET",
                          dataType: "json",
                          data : {
                              userRegionDetail : selectedCodeId
                          },
                          success: function (data) {
                              markers = [];
                              drawMarker(data);
                              for(var i=0; i< markers.length ; i++){
                                  markers[i].setMap(map);
                              }

                              isLoading = false;
                          },
                          error: function (err) {
                              alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
                          }
                      });
                  }
              }
      });
  });






  /*달력 SETTING START*/
  function setDatePicker(){

    //datepicker 초기화 START
    $('#datePicker').datepicker();

    $('#searchStartDt').datepicker();
    $('#searchStartDt').datepicker("option", "onClose", function ( selectedDate ) {
      $("#searchEndDt").datepicker( "option", "minDate", selectedDate );

      var date = new Date(selectedDate);
      date = new Date(date.getFullYear() + "-12-31");
        $("#searchEndDt").datepicker( "option", "maxDate", date );
    });

    $('#searchEndDt').datepicker();
    $('#searchEndDt').datepicker("option", "onClose", function ( selectedDate ) {
      //$("#searchStartDt").datepicker( "option", "maxDate", selectedDate );
    });

    var date = new Date();
    var searchStartDt = date.getFullYear() + "-" + ((date.getMonth() + 1) > 9 ? (date.getMonth() + 1).toString() : "0" + (date.getMonth() + 1)) + "-01";
      var searchEndDt = date.getFullYear() + "-" + ((date.getMonth() + 1) > 9 ? (date.getMonth() + 1).toString() : "0" + (date.getMonth() + 1)) + "-" + (date.getDate() > 9 ? date.getDate().toString() : "0" + date.getDate().toString());

      $('#searchStartDt').val(searchStartDt);
      $('#searchEndDt').val(searchEndDt);
      startDate = searchStartDt;
      endDate = searchEndDt;
    //datepicker 초기화 END
  }
  /*달력 SETTING END*/



  var searchUserRegion;
  var smellValue;
  var smellType;
  var startDate;
  var endDate;
  function handleChange(e) { // select 박스 handler function
      if (e.id == "searchUserRegion") {
          searchUserRegion = e.value;
      } else if (e.id == "smellValue") {
          if (e.value == '001') {
              $('#smellType').attr('disabled','disabled');
              $('#smellType').val('008').prop('selected',true);
          } else {
              $('#smellType').removeAttr('disabled');
              $('#smellType').val('').prop('selected',true);
          }
          smellValue = e.value;
      } else if (e.id == "smellType") {
          smellType = e.value;
      } else if (e.id == "searchStartDt") {
          startDate = e.value;
      } else if (e.id == "searchEndDt") {
          var oneDay = new Date(e.value);
          oneDay.setDate(oneDay.getDate() + 1)

          console.log(oneDay);
          oneDay =  dateFormat(oneDay);
          endDate = oneDay;

      }
  }



  function fnSearch() {
      for (var i = 0 ; i < markers.length ; i++) {
          markers[i].setMap(null);
      }
      for (var i = 0 ; i < clusterers.length ; i++) {
          clusterers[i].clear();
      }
      for (var i = 0 ; i < customOverlayArray.length ; i++) {
          customOverlayArray[i].setMap(null);
          // customOverlayArray = [];
      }

      //지도 기본 설정 -> 한라산 중심 잡아둠, Zoom Level 9
      // var latitude  = 33.3617168;
      // var longitude = 126.5204023;
      //map = focusMapCenter(latitude, longitude, 9);
      // map.setLevel(9, {anchor: new kakao.maps.LatLng(latitude, longitude)});

      // // 마커 클러스터러를 생성합니다
      // var clusterer = new kakao.maps.MarkerClusterer({
      //     map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
      //     averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
      //     minLevel: 9 // 클러스터 할 최소 지도 레벨
      // });
      //
      // $.ajax({
      //     url: "/pcMainListFindByMember",
      //     type: "GET",
      //     dataType: "json",
      //     data : {
      //         userRegionDetail : searchUserRegion,
      //         startDate : startDate,
      //         endDate : endDate,
      //         smellType : smellType,
      //         smellValue : smellValue
      //     },
      //     success: function (data) {
      //         drawMarker(data);
      //         for(var i=0; i< markers.length ; i++){
      //             markers[i].setMap(map);
      //         }
      //         map.panTo( new kakao.maps.LatLng(latitude, longitude));
      //         // 클러스터러에 마커들을 추가합니다
      //         clusterer.addMarkers(markers);
      //     },
      //     error: function (err) {
      //         alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
      //     }
      // });

      $.ajax({
          url : "/pcMainListSelectAll",
          type : "GET",
          dataType : "json",
          data : {
              userRegionDetail : searchUserRegion,
              startDate : startDate,
              endDate : endDate,
              smellType : smellType,
              smellValue : smellValue
          },
          success: function (data) {
              for (var i = 0 ; i < data.length ; i++ ) {

                  // 커스텀 오버레이에 표시할 내용입니다
                  // HTML 문자열 또는 Dom Element 입니다
                  console.log("data[i].codeId : " + data[i].codeId)
                  var content = '<div class ="label"><span class="left"></span><span class="center"><a style="text-decoration: none; color: black" href="javascript:void(0);" onclick="test('+ "'" +data[i].codeId+"'" +','+ data[i].gpsY + ',' + data[i].gpsX+')">'+ data[i].userRegionDetail + ' : ' +data[i].totalCount+ '</a></span><span class="right"></span></div>';

                  // 커스텀 오버레이가 표시될 위치입니다
                  var position = new kakao.maps.LatLng(data[i].gpsY, data[i].gpsX);

                  // 커스텀 오버레이를 생성합니다
                  var customOverlay = new kakao.maps.CustomOverlay({
                      position: position,
                      content: content
                  });

                  // 커스텀 오버레이를 지도에 표시합니다
                  customOverlay.setMap(map);
                  customOverlayArray.push(customOverlay);

                  isLoading = false;
              }
          },
          error: function (err) {
              alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
          }
      })
  }


  // 마커 클릭 이벤트
  function clickMarker(id) {
    //클릭된 infoWindow 또는 marker를 찾아 지도 가운데 이동
    var index = id.replace("marker","").replace("infoWindow","");
    var moveLatLon = new kakao.maps.LatLng($("#latitude"+index).val(), $("#longitude"+index).val());
    map.panTo(moveLatLon);
    showWeatherStatus(index);
  }
  function drawMarker(arrays) {

      // 메인 화면에서 검색 시 마커 초기화 후 지도에 뿌림
      //markers = [];

      var customOverlay;

      for (var i = 0 ; i < customOverlayArray.length ; i++) {
          customOverlayArray[i].setMap(null);
          // customOverlayArray = [];
      }


    for (var i = 0; i < arrays.length; i++) {
        if (arrays[i].smellValue != null || arrays[i].smellValue != undefined) {
            console.log("marker Here!");
            if(arrays[i].gpsX != "" && arrays[i].gps != "") {
                var markerImage = returnMarkerImage(arrays[i].smellValue);
                // 마커를 생성합니다
                var marker = new kakao.maps.Marker({
                    map: map, // 마커를 표시할 지도
                    position: new kakao.maps.LatLng(arrays[i].gpsY, arrays[i].gpsX), // 마커를 표시할 위치
                    image: markerImage // 마커 이미지
                });




                marker.id = "marker" + i;


                if (arrays[i].weatherStateName == "구름많음") weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_cloud_gray.png' width='30' height='30'/>";
                else if (arrays[i].weatherStateName == "맑음") weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_sun.png' width='30' height='30'/>";
                else if (arrays[i].weatherStateName == "흐림") weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_cloud_sun_gray.png' width='30' height='30'/>";
                else if (arrays[i].weatherStateName == "눈" || arrays[i].weatherStateName == "눈날림") weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_snow_gray.png' width='30' height='30'/>";
                else if (arrays[i].weatherStateName == "비" || arrays[i].weatherStateName == "빗방울") weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_cloud_gray.png' width='30' height='30'/>";
                else if (arrays[i].weatherStateName == "소나기") weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_shower_gray.png' width='30' height='30'/>";
                else if (arrays[i].weatherStateName == "빗방울/눈날림") weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_sleet_gray.png' width='30' height='30'/>";
                else
                    weather     = "(-)";

                var iwContent = '<div id="infoWindow' + i + '" class="cursor_pointer infoWindow" style="padding:5px; font-size:12px;">' + arrays[i].userName + '' +
                    '<br>' + arrays[i].regDt + '' +
                    '<br>' + "날씨 : " + weather + '' +
                    '<br>' + "기온 : " + arrays[i].temperatureValue + '' +
                    '<br>' + "습도 : " + arrays[i].humidityValue + '' +
                    '<br>' + "풍향 : " + arrays[i].windDirectionValueName + '' +
                    '<br>' + "풍속 : " + arrays[i].windSpeedValue + '' +
                    '</div>'; // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다

                iwContent += '<input type="hidden" id = "latitude' + i + '" value ="' + arrays[i].gpsY + '"/>';
                iwContent += '<input type="hidden" id = "longitude' + i + '" value ="' + arrays[i].gpsX + '"/>';
                iwContent += '<input type="hidden" id = "weatherStateName' + i + '" value ="' + arrays[i].weatherStateName + '"/>';
                iwContent += '<input type="hidden" id = "temperatureValue' + i + '" value ="' + arrays[i].temperatureValue + '"/>';
                iwContent += '<input type="hidden" id = "humidityValue' + i + '" value ="' + arrays[i].humidityValue + '"/>';
                iwContent += '<input type="hidden" id = "windDirectionValue' + i + '" value ="' + arrays[i].windDirectionValueName + '"/>';
                iwContent += '<input type="hidden" id = "windSpeedValue' + i + '" value ="' + arrays[i].windSpeedValue + '"/>';

                var iwRemoveable = true;
                // 인포윈도우를 생성합니다
                var infowindow = new kakao.maps.InfoWindow({
                    zIndex:1,
                    content: iwContent,
                    removable : iwRemoveable // removeable 속성을 ture 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됩니다
                });

                infoWindows.push(infowindow);


                // 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
                // 이벤트 리스너로는 클로저를 만들어 등록합니다
                // for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
                kakao.maps.event.addListener(marker, 'click', clickListener(map, marker, infowindow));

                markers.push(marker);

                console.log("drawMarker : " + markers.length);
            }
        } else {
            console.log(typeof arrays[i].codeId);
            // 커스텀 오버레이에 표시할 내용입니다
            // HTML 문자열 또는 Dom Element 입니다
            var content = '<div class ="label"><span class="left"></span><span class="center"><a style="text-decoration: none; color: black" href="javascript:void(0);" onclick="test('+arrays[i].codeId +','+ arrays[i].gpsY + ',' + arrays[i].gpsX+')">'+ arrays[i].userRegionDetail + ' : ' +arrays[i].totalCount+ '</a></span><span class="right"></span></div>';

            // 커스텀 오버레이가 표시될 위치입니다
            var position = new kakao.maps.LatLng(arrays[i].gpsY, arrays[i].gpsX);

            // 커스텀 오버레이를 생성합니다
            customOverlay = new kakao.maps.CustomOverlay({
                position: position,
                content: content
            });

            // 커스텀 오버레이를 지도에 표시합니다
            customOverlay.setMap(map);

            customOverlayArray.push(customOverlay)


        }

    }
  }



  function test(codeId, gpsx , gpsy) {

      $(".label").css('display','none');
      console.log("selectedCodeId : " + codeId)
      console.log("시작 : " + new Date().toTimeString().split(' ')[0])


      selectedCodeId = codeId;
      selectedGpsX = gpsx;
      selectedGpsY = gpsy;

      console.log("test Click selectedCodeId : " + selectedCodeId)


      map.setLevel(5, {anchor: new kakao.maps.LatLng(gpsx, gpsy)});

      /*if (gpsx == "33.3212026") { // 파라미터값이 제대로 안들어가서 하드코딩
          codeId = "010";
      } else if (gpsx =="33.2456108") {
          codeId = "011";
      } else if (gpsx =="33.247276") {
          codeId = "012";
      }

      console.log("codeId : " + codeId);
      console.log("gpsx : " + gpsx);
      console.log("gpsy : " + gpsy);

      var latitude  = gpsx;
      var longitude = gpsy;



    // 마커 클러스터러를 생성합니다
      var clusterer = new kakao.maps.MarkerClusterer({
          map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
          averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
          minLevel: 4, // 클러스터 할 최소 지도 레벨
          minClusterSize : 1,
          calculator: [10, 50, 100, 150, 200],
          gridSize : 150
      });


      $.ajax({
          url: "/pcMainListFindByMember",
          type: "GET",
          dataType: "json",
          data : {
              userRegionDetail :  codeId,
              startDate : startDate,
              endDate : endDate,
              smellType : smellType,
              smellValue : smellValue
          },
          success: function (data) {

              drawMarker(data);
              for(var i=0; i< markers.length ; i++){
                  markers[i].setMap(map);
              }
              map.panTo( new kakao.maps.LatLng(latitude, longitude));
              // 클러스터러에 마커들을 추가합니다
              clusterer.addMarkers(markers);



              console.log("끝 : " + new Date().toTimeString().split(' ')[0])
          },
          error: function (err) {
              alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
          }
      });

      map.setLevel(
          6,
          {
              anchor: new kakao.maps.LatLng(gpsx, gpsy)
          }
      );

      beforeLevel = 9;

      kakao.maps.event.addListener(map, 'zoom_changed', function() {
          console.log("codeId : " + codeId);

          var afterLevel = map.getLevel();

          if (afterLevel >= 2 && afterLevel < 3 ) {
              console.log("탐 ? afterLevel : " + afterLevel);
          } else if (afterLevel <= 3) {
              /!*map = focusMapCenter(latitude, longitude, 4);
              $.ajax({
                  url: "/pcMainListSelect",
                  type: "GET",
                  dataType: "json",
                  data : {
                      userRegionDetail : codeId
                  },
                  success: function (data) {
                      drawMarker(data);
                      for(var i=0; i< markers.length ; i++){
                          markers[i].setMap(map);
                      }
                      map.panTo( new kakao.maps.LatLng(data[0].gpsY, data[0].gpsX));

                      kakao.maps.event.addListener(map, 'zoom_changed', function() {
                          console.log("come");

                            if (map.getLevel() > 4 && map.getLevel() < 7) {
                                for (var i = 0 ; i < markers.length ; i++) {
                                    markers[i].setMap(null);
                                }
                                // 마커 클러스터러를 생성합니다
                                var clusterer = new kakao.maps.MarkerClusterer({
                                    map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
                                    averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
                                    minLevel: 4, // 클러스터 할 최소 지도 레벨
                                    minClusterSize : 1,
                                    calculator: [10, 50, 100, 150, 200],
                                    gridSize : 150
                                });

                                markers = [];
                                console.log("LeveL 7 : " + markers);

                                $.ajax({
                                    url: "/pcMainListFindByMember",
                                    type: "GET",
                                    dataType: "json",
                                    data : {
                                        userRegionDetail :  codeId,
                                        startDate : startDate,
                                        endDate : endDate,
                                        smellType : smellType,
                                        smellValue : smellValue
                                    },
                                    success: function (data) {

                                        drawMarker(data);
                                        for(var i=0; i< markers.length ; i++){
                                            markers[i].setMap(map);
                                        }
                                        map.panTo( new kakao.maps.LatLng(latitude, longitude));
                                        // 클러스터러에 마커들을 추가합니다
                                        clusterer.addMarkers(markers);



                                        console.log("끝 : " + new Date().toTimeString().split(' ')[0])
                                    },
                                    error: function (err) {
                                        alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
                                    }
                                });

                            }
                      });
                  },
                  error: function (err) {
                      alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
                  }
              });*!/
          }

          console.log("afterLevel : " + afterLevel);
          console.log("beforeLevel : " + beforeLevel);

          if (afterLevel > beforeLevel || afterLevel == 8) {
              closeInfoWindows();
          }

          beforeLevel = afterLevel;

      });*/
  }

  function closeInfoWindows() {
      for (var idx = 0 ; idx < infoWindows.length ; idx++ ) {
          infoWindows[idx].close();
      }
  }

  // 인포윈도우를 표시하는 클로저를 만드는 함수입니다
  function clickListener(map, marker, infowindow) {
    return function() {
        closeInfoWindows();
        infowindow.open(map, marker);
        clickMarker(marker.id);
    };
  }

  function lpad(val, padLength, padString){
      while(val.length < padLength){
          val = padString + val;
      }
      return val;
  }

  //기상상태가 안보이는 상태일때 다시 보이게 함
  function showWeatherStatus(index){

    /*메인 페이지 날씨 이모티콘 SETTING START*/
    var weatherName = $("#weatherStateName"+index).val();
    var weather     = "";

    if(weatherName == "구름많음")
      weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_cloud_gray.png' width='30' height='30'/>";
    else if(weatherName == "맑음")
      weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_sun.png' width='30' height='30'/>";
    else if(weatherName == "흐림")
      weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_cloud_sun_gray.png' width='30' height='30'/>";
    else if(weatherName == "눈" || weatherName == "눈날림")
      weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_snow_gray.png' width='30' height='30'/>";
    else if(weatherName == "비" || weatherName == "빗방울")
      weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_rain_gray.png' width='30' height='30'/>";
    else if(weatherName == "소나기")
      weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_shower_gray.png' width='30' height='30'/>";
    else if(weatherName == "빗방울/눈날림")
      weather = "<img style=' position: relative; top:7px' src='/resources/image/weather/weather_sleet_gray.png' width='30' height='30'/>";
    else
      weather     = "(-)";
    /*메인 페이지 날씨 이모티콘 SETTING END*/

    if($(".weatherStatus").css("display")=="none") $(".weatherStatus").css("display","");
    $("#weatherState").text($("#weatherStateName"+index).val()+"");
    $("#weatherState").html(weather+" "+$("#weatherStateName"+index).val());
    $("#temperatureValue").text(addUnit($("#temperatureValue"+index).val(),"temperature"));
    $("#humidityValue").text(addUnit($("#humidityValue"+index).val(),"humidity"));
    $("#windDirectionValue").text($("#windDirectionValue"+index).val());
    $("#windSpeedValue").text(addUnit($("#windSpeedValue"+index).val(),"speed"));

  }
</script>
<body>
<jsp:include page="/menu"/>
<div class="bgc_w wd100rate h100rate fl">
  <div id="leftSide" class="dp_inlineBlock wd20rate">
    <table class="mainForm wd100rate h100rate">
      <tr><th>악취 강도</th></tr>
      <tr><td class="h200">
        <div class="wd50rate h50 fl"><div class="mapLegend bgcSkyBlue"></div><label class="mapLegendLabel">${CG_SMT[0].codeIdName}</label></div>
        <div class="wd50rate h50 fl"><div class="mapLegend bgcLightGreen"></div><label class="mapLegendLabel">${CG_SMT[1].codeIdName}</label></div>
        <div class="wd50rate h50 fl"><div class="mapLegend bgcWhite"></div><label class="mapLegendLabel">${CG_SMT[2].codeIdName}</label></div>
        <div class="wd50rate h50 fl"><div class="mapLegend bgcYellow"></div><label class="mapLegendLabel">${CG_SMT[3].codeIdName}</label></div>
        <div class="wd50rate h50 fl"><div class="mapLegend bgcOrange"></div><label class="mapLegendLabel">${CG_SMT[4].codeIdName}</label></div>
        <div class="wd50rate h50 fl"><div class="mapLegend bgcDeepRed"></div><label class="mapLegendLabel">${CG_SMT[5].codeIdName}</label></div>
      </td></tr>
    </table>
    <table class="mainForm wd100rate h100rate" style="border-bottom: 1px #10639a solid; border-top: 1px #10639a solid;">
        <tbody style="text-align: center">
            <tr>
                <th>군집 정도</th>
            </tr>
            <tr>
                <td>
                    <div class="wd50rate h50 fl">
                        <div class="kakaoClusterPointBlue"></div>
                        <label class="kakaoClusterInfoText">10 미만</label>
                    </div>
                    <div class="wd50rate h50 fl">
                        <div class="kakaoClusterPointGreen"></div>
                        <label class="kakaoClusterInfoText">10 이상 ~ 50 미만</label>
                    </div>
                    <div class="wd50rate h50 fl">
                        <div class="kakaoClusterPointYellow"></div>
                        <label class="kakaoClusterInfoText">50 이상 ~ 100 미만</label>
                    </div>
                    <div class="wd50rate h50 fl">
                        <div class="kakaoClusterPointBrown"></div>
                        <label class="kakaoClusterInfoText">100 이상 ~ 150 미만</label>
                    </div>
                    <div class="wd50rate h50 fl">
                        <div class="kakaoClusterPointRed"></div>
                        <label class="kakaoClusterInfoText">150이상</label>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
    <table class="mainForm wd100rate h100rate" style="border-bottom: 1px #10639a solid; border-top: 1px #10639a solid;">
      <tbody style="text-align: center">
      <tr>
          <th colspan="3" style="width: 100%">검색 조건</th>
      </tr>
      <tr>
          <td style="background: #d9efff;" class="wd50">지역</td>
          <td class="wd80">
              <select id="searchUserRegion" name="userRegionDetail" class="wd70" onchange="handleChange(this)" style="font-size: 11px;">
                  <option value="">전체</option>
                  <c:forEach var="item" items="${CG_RGD}">
                      <option value="${item.codeId}">${item.codeIdName}</option>
                  </c:forEach>
              </select>
          </td>
          <td>
              <input type="date" name="startDate" class="mDateTimeInputMain" value="${mainSearchVo.startDate}" onchange="handleChange(this)"
                     id="searchStartDt" readonly="readonly">
              ~
              <input type="date" name="endDate" class="mDateTimeInputMain" value="${mainSearchVo.endDate}" id="searchEndDt" onchange="handleChange(this)"
                     readonly="readonly">
          </td>
      </tr>
      </tbody>
    </table>
          <div class="pd15">
              <select id="smellValue" name="smellValue" onchange="handleChange(this)">
                  <option value="">전체</option>
                  <c:forEach var="item" items="${CG_SMT}">
                      <option value="${item.codeId}">${item.codeIdName}</option>
                  </c:forEach>
              </select>
              <select id="smellType" name="smellType" class="wd30rate" onchange="handleChange(this)">
                  <option value="">전체</option>
                  <c:forEach var="item" items="${CG_STY}">
                      <option value="${item.codeId}">${item.codeIdName}</option>
                  </c:forEach>
              </select>
          </div>
    <a class="button bgcSkyBlue mt10 fr" onclick="fnSearch()"><i class="bx bx-search"></i>조회</a>

  </div>
  <div id="rightSide" class="fr wd80rate h100rate" style="border-left: 1px solid #10639a; margin-left: -1px;">
    <div id="map" class="wd100rate h100rate mg0auto" style="z-index: 1;"></div>
  </div>
</div>
</body>
</html>
