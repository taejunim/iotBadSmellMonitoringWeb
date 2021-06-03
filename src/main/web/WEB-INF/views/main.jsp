<!--
  Created by IntelliJ IDEA.
  User: 조유영
  Date: 2021/05/27
  Time: 9:49 오전
  메인
-->
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script type="text/javascript">

  $(document).ready(function () {
    setButton("main");

    var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
    var options = { //지도를 생성할 때 필요한 기본 옵션
      center: new kakao.maps.LatLng(33.352974, 126.314419), //지도의 중심좌표.
      level: 5 //지도의 레벨(확대, 축소 정도)
    };

    var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴

    var arrays = [
      {
        gpxX : 126.311670, gpxY : 33.355204 , userName : "이름1" , regDt : "2021-06-01 12:00:00" , smellValue : '001'
      },
      {
        gpxX : 126.296283, gpxY : 33.357326 , userName : "이름4" , regDt : "2021-06-01 12:00:00" , smellValue : '003'
      },
      {
        gpxX : 126.311670, gpxY : 33.359518 , userName : "이름3" , regDt : "2021-06-01 12:00:00" , smellValue : '004'
      },
      {
        gpxX : 126.311670, gpxY : 33.344509 , userName : "이름2" , regDt : "2021-06-01 12:00:00" , smellValue : '005'
      }
    ];

   // 마커 이미지 주소
    var bluePinSrc   = "resources/image/marker/bluePin.png";
    var greenPinSrc  = "resources/image/marker/greenPin.png";
    var whitePinSrc  = "resources/image/marker/whitePin.png";
    var yellowPinSrc = "resources/image/marker/yellowPin.png";
    var orangePinSrc = "resources/image/marker/orangePin.png";
    var redPinSrc    = "resources/image/marker/redPin.png";

    // 마커 이미지 크기
    var imageSize = new kakao.maps.Size(35, 35);
    // 마커 이미지 생성
    var bluePin   = new kakao.maps.MarkerImage(bluePinSrc, imageSize);
    var greenPin  = new kakao.maps.MarkerImage(greenPinSrc, imageSize);
    var whitePin  = new kakao.maps.MarkerImage(whitePinSrc, imageSize);
    var yellowPin = new kakao.maps.MarkerImage(yellowPinSrc, imageSize);
    var orangePin = new kakao.maps.MarkerImage(orangePinSrc, imageSize);
    var redPin    = new kakao.maps.MarkerImage(redPinSrc, imageSize);


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

      var iwContent = '<div style="padding:5px; font-size:12px;">'+ arrays[i].userName +'<br>'+ arrays[i].regDt +'</div>'; // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다

      // 인포윈도우를 생성합니다
      var infowindow = new kakao.maps.InfoWindow({
        content : iwContent
      });

// 마커 위에 인포윈도우를 표시합니다. 두번째 파라미터인 marker를 넣어주지 않으면 지도 위에 표시됩니다
      infowindow.open(map, marker);
    }

  });

</script>
  <body>
  <jsp:include page="/menu"/>
  <div class="bgc_w wd100rate h100rate fl">
    <div id="leftSide" class="dp_inlineBlock" style="width: 30%;">
      <table class="mainForm wd100rate h100rate">
        <tr><th>악취 강도</th></tr>
        <tr><td class="h300"></td></tr>
        <tr><th>기상 상태</th></tr>
        <tr><td>
          <table class="wd90rate mt30" style="margin-left:auto; margin-right: auto;">
            <tr>
              <th>날씨</th><td colspan="3">빗방울/눈날림</td>
            </tr>
            <tr>
              <th>기온</th><td colspan="3"> 25 ℃</td><th>습도</th><td colspan="3">10 %</td>
            </tr>
            <tr>
              <th>풍향</th><td colspan="3">북서</td><th>풍속</th><td colspan="3"> 3.4 m/s</td>
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
