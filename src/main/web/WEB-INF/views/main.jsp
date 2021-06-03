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
      center: new kakao.maps.LatLng(33.450701, 126.570667), //지도의 중심좌표.
      level: 3 //지도의 레벨(확대, 축소 정도)
    };

    var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
  });

</script>
  <body>
  <jsp:include page="/menu"/>
  <div class="bgc_w wd100rate h100rate fl">
    <div id="leftSide" class="dp_inlineBlock" style="width: 30%; height: 100%">
    </div>
    <div id="rightSide" class="fr" style="width:70%; height: 100% ">
      <div id="map" class="wd100rate h100rate"></div>
    </div>
  </div>
  </body>
</html>
