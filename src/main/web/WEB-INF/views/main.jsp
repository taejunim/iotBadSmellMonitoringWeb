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
  $(document).ready(function (listener) {
    setButton("main");
    $(".weatherStatus").css("display","none");

    map = focusMapCenter(33.352974, 126.314419, 5);
    var arrays = [
      {
        gpxX : 126.311670, gpxY : 33.355204 , userName : "이름1" , regDt : "2021-06-01 12:00:00" , smellValue : '001' , temperatureValue : 25 , weatherState : "001"
      },
      {
        gpxX : 126.296283, gpxY : 33.357326 , userName : "이름4" , regDt : "2021-06-01 12:00:00" , smellValue : '003' , temperatureValue : 24 , weatherState : "002"
      },
      {
        gpxX : 126.311670, gpxY : 33.359518 , userName : "이름3" , regDt : "2021-06-01 12:00:00" , smellValue : '004' , temperatureValue : 21 , weatherState : "004"
      },
      {
        gpxX : 126.311670, gpxY : 33.344509 , userName : "이름2" , regDt : "2021-06-01 12:00:00" , smellValue : '005' , temperatureValue : 30 , weatherState : "006"
      }
    ];

    for (var i = 0; i < arrays.length; i ++) {

      var markerImage;

      if(arrays[i].smellValue == '001')       markerImage = bluePin;
      else if(arrays[i].smellValue == '002')  markerImage = greenPin;
      else if(arrays[i].smellValue == '003')  markerImage = whitePin;
      else if(arrays[i].smellValue == '004')  markerImage = yellowPin;
      else if(arrays[i].smellValue == '005')  markerImage = orangePin;
      else if(arrays[i].smellValue == '006')  markerImage = redPin;

      // 마커를 생성합니다
      var marker = new kakao.maps.Marker({
        map: map, // 마커를 표시할 지도
        position: new kakao.maps.LatLng(arrays[i].gpxY,  arrays[i].gpxX), // 마커를 표시할 위치
        image: markerImage // 마커 이미지
      });

      marker.id = "marker" + i;

      var iwContent = '<div id="infoWindow'+ i +'" class="cursor_pointer infoWindow" style="padding:5px; font-size:12px;">'+ arrays[i].userName +'<br>'+ arrays[i].regDt +'</div>'; // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
      iwContent += '<input type="hidden" id = "latitude' + i + '" value ="' + arrays[i].gpxY + '"/>';
      iwContent += '<input type="hidden" id = "longitude' + i + '" value ="' + arrays[i].gpxX + '"/>';
      iwContent += '<input type="hidden" id = "weatherState' + i + '" value ="' + arrays[i].weatherState + '"/>';
      iwContent += '<input type="hidden" id = "temperatureValue' + i + '" value ="' + arrays[i].temperatureValue + '"/>';
      // 인포윈도우를 생성합니다
      var infowindow = new kakao.maps.InfoWindow({
        content : iwContent,
      });

      // 마커 위에 인포윈도우를 표시합니다. 두번째 파라미터인 marker를 넣어주지 않으면 지도 위에 표시됩니다
      infowindow.open(map, marker);
      // 마커 이벤트 연결
      kakao.maps.event.addListener(marker, 'click', function() {clickMarker($(this)[0].id)});
    }

    $(".infoWindow").click(function(event){
      clickMarker(event.target.id);
    });

  });
  // 마커 클릭 이벤트
  function clickMarker(id) {
     //클릭된 infoWindow 또는 marker를 찾아 지도 가운데 이동
     var index = id.replace("marker","").replace("infoWindow","");
     var moveLatLon = new kakao.maps.LatLng($("#latitude"+index).val(), $("#longitude"+index).val());
     map.panTo(moveLatLon);
     showWeaterStatus(index);
  }
  //기상상태가 안보이는 상태일때 다시 보이게 함
  function showWeaterStatus(index){
    if($(".weatherStatus").css("display")=="none") $(".weatherStatus").css("display","");
    $("#weatherState").text(setWeatherState($("#weatherState"+index).val()));
    $("#temperatureValue").text($("#temperatureValue"+index).val() + " ℃");

  }
  function setWeatherState(weatherState) {
    switch (weatherState) {
      case "001" : return "맑음";
      case "002" : return "구름많음";
      case "003" : return "흐림";
      case "004" : return "비";
      case "005" : return "비/눈";
      case "006" : return "눈";
      case "007" : return "소나기";
      case "008" : return "빗방울";
      case "009" : return "빗방울/눈날림";
      case "010" : return "눈날림";
    }
  }
</script>
  <body>
  <jsp:include page="/menu"/>
  <div class="bgc_w wd100rate h100rate fl">
    <div id="leftSide" class="dp_inlineBlock" style="width: 30%;">
      <table class="mainForm wd100rate h100rate">
        <tr><th>악취 강도</th></tr>
        <tr><td class="h200">
          <div class="wd50rate h50 fl"><div class="mapLegend bgcSkyBlue"></div><label class="mapLegendLabel">무취</label></div>
          <div class="wd50rate h50 fl"><div class="mapLegend bgcLightGreen"></div><label class="mapLegendLabel">감지 취기</label></div>
          <div class="wd50rate h50 fl"><div class="mapLegend bgcWhite"></div><label class="mapLegendLabel">보통 취기</label></div>
          <div class="wd50rate h50 fl"><div class="mapLegend bgcYellow"></div><label class="mapLegendLabel">강한 취기</label></div>
          <div class="wd50rate h50 fl"><div class="mapLegend bgcOrange"></div><label class="mapLegendLabel">극심한 취기</label></div>
          <div class="wd50rate h50 fl"><div class="mapLegend bgcDeepRed"></div><label class="mapLegendLabel">참기 어려운 취기</label></div>
        </td></tr>
        <tr class="weatherStatus"><th>기상 상태</th></tr>
        <tr class="weatherStatus"><td>
          <table class="wd90rate mt30" style="margin-left:auto; margin-right: auto;">
            <tr>
              <th>날씨</th><td colspan="3" id="weatherState">빗방울/눈날림</td>
            </tr>
            <tr>
              <th>기온</th><td colspan="3" id="temperatureValue"> 25 ℃</td><th>습도</th><td colspan="3" id="humidityValue">10 %</td>
            </tr>
            <tr>
              <th>풍향</th><td colspan="3" id="windDirectionValue">북서</td><th>풍속</th><td colspan="3" id="windSpeedValue"> 3.4 m/s</td>
            </tr>
          </table>
        </td></tr>
      </table>
    </div>
    <div id="rightSide" class="fr" style="width:70%; height: 100% ">
      <div id="map" class="wd100rate h100rate"></div>
    </div>
  </div>
  </body>
</html>
