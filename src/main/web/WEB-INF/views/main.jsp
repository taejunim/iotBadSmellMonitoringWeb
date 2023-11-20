<!--
Created by IntelliJ IDEA.
User: 조유영
Date: 2021/05/27
Time: 9:49 오전
메인
-->
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script src="/resources/js/kakaoMapUtils.js"></script>
<script type="text/javascript">
  var map;
  var markers = [];
  var infoWindows = [];
  $(document).ready(function () {
    setButton("main");
    setDatePicker();                        //달력 SETTING CALL.
    $(".weatherStatus").css("display","none");

    //지도 기본 설정 -> 한라산 중심 잡아둠, Zoom Level 9
    var latitude  = 33.3617168;
    var longitude = 126.5204023;
    map = focusMapCenter(latitude, longitude, 9);

    $.ajax({
      url: "/pcMainListSelect",
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
        clusterer.addMarkers(markers);
      },
      error: function (err) {
        alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
      }
    });

    //마커 위 infoWindow에도 이벤트 연결
    $(document).on("click",".infoWindow",function(event){
      clickMarker(event.target.id);
    });




    // 마커 클러스터러를 생성합니다
    var clusterer = new kakao.maps.MarkerClusterer({
        map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
        averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
        minLevel: 8, // 클러스터 할 최소 지도 레벨
        gridSize: 100,
        calculator: [10, 50, 100, 150, 200]
    });

    // 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
    var zoomControl = new kakao.maps.ZoomControl();
    map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

    var beforeLevel = 9;

    kakao.maps.event.addListener(map, 'zoom_changed', function() {


        var afterLevel = map.getLevel();

        if (afterLevel > beforeLevel && afterLevel == 8) {
            closeInfoWindows();
        }

        beforeLevel = afterLevel;

        console.log("lever : " + afterLevel);

    });


  });






  /*달력 SETTING START*/
  function setDatePicker(){

    //datepicker 초기화 START
    $('#datePicker').datepicker();

    $('#searchStartDt').datepicker();
    $('#searchStartDt').datepicker("option", "maxDate", $("#searchEndDt").val());
    $('#searchStartDt').datepicker("option", "onClose", function ( selectedDate ) {
      $("#searchEndDt").datepicker( "option", "minDate", selectedDate );
    });

    $('#searchEndDt').datepicker();
    $('#searchEndDt').datepicker("option", "minDate", $("#searchStartDt").val());
    $('#searchEndDt').datepicker("option", "onClose", function ( selectedDate ) {
      $("#searchStartDt").datepicker( "option", "maxDate", selectedDate );
    });
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
              $('#smellType').val('').prop('selected',true);
          } else {
              $('#smellType').removeAttr('disabled');
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
      //지도 기본 설정 -> 한라산 중심 잡아둠, Zoom Level 9
      var latitude  = 33.3617168;
      var longitude = 126.5204023;
      map = focusMapCenter(latitude, longitude, 9);

      // 마커 클러스터러를 생성합니다
      var clusterer = new kakao.maps.MarkerClusterer({
          map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
          averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
          minLevel: 9 // 클러스터 할 최소 지도 레벨
      });

      $.ajax({
          url: "/pcMainListFindByMember",
          type: "GET",
          dataType: "json",
          data : {
              userRegionDetail : searchUserRegion,
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
          },
          error: function (err) {
              alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
          }
      });
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
      markers = [];

    for (var i = 0; i < arrays.length; i++) {

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
      }
    }
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
