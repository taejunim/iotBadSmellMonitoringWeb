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
  $(document).ready(function () {
    setButton("main");
    $(".weatherStatus").css("display","none");

    //지도 기본 설정 -> 금악초 근처 중심 잡아둠, Zoom Level 8
    var latitude  = 33.357562;
    var longitude = 126.296253;
    map = focusMapCenter(latitude, longitude, 8);

    $.ajax({
      url: "/pcMainListSelect",
      type: "GET",
      dataType: "json",
      success: function (data) {
        showLoader(false);
        drawMarker(data);
        for(var i=0; i< markers.length ; i++){
          markers[i].setMap(map);
        }
        map.panTo( new kakao.maps.LatLng(33.357562, 126.296253));
      },
      error: function (err) {
        alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
      }
    });

    //마커 위 infoWindow에도 이벤트 연결
    $(document).on("click",".infoWindow",function(event){
      clickMarker(event.target.id);
    });

  });

  // 마커 클릭 이벤트
  function clickMarker(id) {
     //클릭된 infoWindow 또는 marker를 찾아 지도 가운데 이동
     var index = id.replace("marker","").replace("infoWindow","");
     var moveLatLon = new kakao.maps.LatLng($("#latitude"+index).val(), $("#longitude"+index).val());
     map.panTo(moveLatLon);
     showWeatherStatus(index);
  }
  function drawMarker(arrays) {

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

        var iwContent = '<div id="infoWindow' + i + '" class="cursor_pointer infoWindow" style="padding:5px; font-size:12px;">' + arrays[i].userName + '<br>' + arrays[i].regDt + '</div>'; // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
        iwContent += '<input type="hidden" id = "latitude' + i + '" value ="' + arrays[i].gpsY + '"/>';
        iwContent += '<input type="hidden" id = "longitude' + i + '" value ="' + arrays[i].gpsX + '"/>';
        iwContent += '<input type="hidden" id = "weatherStateName' + i + '" value ="' + arrays[i].weatherStateName + '"/>';
        iwContent += '<input type="hidden" id = "temperatureValue' + i + '" value ="' + arrays[i].temperatureValue + '"/>';
        iwContent += '<input type="hidden" id = "humidityValue' + i + '" value ="' + arrays[i].humidityValue + '"/>';
        iwContent += '<input type="hidden" id = "windDirectionValue' + i + '" value ="' + arrays[i].windDirectionValueName + '"/>';
        iwContent += '<input type="hidden" id = "windSpeedValue' + i + '" value ="' + arrays[i].windSpeedValue + '"/>';
        // 인포윈도우를 생성합니다
        var infowindow = new kakao.maps.InfoWindow({
          content: iwContent,
        });

        // 마커 위에 인포윈도우를 표시합니다. 두번째 파라미터인 marker를 넣어주지 않으면 지도 위에 표시됩니다
        infowindow.open(map, marker);
        // 마커 이벤트 연결
        kakao.maps.event.addListener(marker, 'click', function () {
          clickMarker($(this)[0].id)
        });
        markers.push(marker);
      }
    }
  }
  //기상상태가 안보이는 상태일때 다시 보이게 함
  function showWeatherStatus(index){

    if($(".weatherStatus").css("display")=="none") $(".weatherStatus").css("display","");
    $("#weatherState").text($("#weatherStateName"+index).val());
    $("#temperatureValue").text(addUnit($("#temperatureValue"+index).val(),"temperature"));
    $("#humidityValue").text(addUnit($("#humidityValue"+index).val(),"humidity"));
    $("#windDirectionValue").text($("#windDirectionValue"+index).val());
    $("#windSpeedValue").text(addUnit($("#windSpeedValue"+index).val(),"speed"));

  }
</script>
  <body>
  <jsp:include page="/menu"/>
  <div class="bgc_w wd100rate h100rate fl">
    <div id="leftSide" class="dp_inlineBlock" style="width: 30%;">
      <div class="ml10 mt10 mb10 font_size13 lh37">
        측정소명/장치ID : ${airSensorName}</br>
        공기질 수집일시 : ${airSensingDate} / PM10 미세먼지 평균 값(㎍/㎥) : ${pm10Avg}
      </div>
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
        <tr class="weatherStatus"><th>기상 상태</th></tr>
        <tr class="weatherStatus"><td>
          <table class="wd90rate mt30" style="margin-left:auto; margin-right: auto;">
            <tr>
              <th>날씨</th><td colspan="3" id="weatherState">빗방울/눈날림</td>
            </tr>
            <tr>
              <th>기온</th><td id="temperatureValue"></td><th>습도</th><td id="humidityValue"></td>
            </tr>
            <tr>
              <th>풍향</th><td id="windDirectionValue"></td><th>풍속</th><td id="windSpeedValue"></td>
            </tr>
          </table>
        </td></tr>
      </table>
    </div>
    <div id="rightSide" class="fr" style="width:70%; height: 100%; border-left: 1px solid #10639a; margin-left: -1px; ">
      <div id="map" class="wd90rate h80rate mg0auto" style="top:2%; z-index: 1;"></div>
    </div>
  </div>
  </body>
</html>
