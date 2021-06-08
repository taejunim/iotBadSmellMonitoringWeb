<%--
  Created by IntelliJ IDEA.
  User: joyuyeong
  Date: 2021/06/08
  Time: 3:27 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script src="/resources/js/kakaoMapUtils.js"></script>
<script src="/resources/js/c3/c3.js"></script>
<script src="/resources/js/c3/d3.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/c3/c3.css">
<script type="text/javascript">
    $(document).ready(function () {
        setButton("statistic");


        var chart = c3.generate({
            bindto: '#chartDiv',
            data: {
                columns: [
                    ['data1', 30, 200, 100, 400, 150, 250],
                    ['data2', 130, 100, 140, 200, 150, 50]
                ],
                type: 'bar'
            },
            bar: {
                width: {
                    ratio: 0.5 // this makes bar width 50% of length between ticks
                }
                // or
                //width: 100 // this makes bar width 100px
            }
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
    <table class="searchTable">
        <tr>
            <th class="wd90">구분</th>
            <td class="wd120">
                <select class="wd100">
                    <option>전체</option>
                </select>
            </td>
            <td>
                <input type="date" class="mDateTimeInput" id="startDatePicker" readonly="readonly"> ~
                <input type="date" class="mDateTimeInput" id="endDatePicker" readonly="readonly">
                <select class="wd200">
                    <option>전체</option>
                </select> ~
                <select class="wd200">
                    <option>전체</option>
                </select>

            </td>
            <td><a class="button bgcSkyBlue mt10 fr"><i class="bx bx-search"></i>조회</a></td>
        </tr>
    </table>
    <div id="leftSide" class="dp_inlineBlock" style="width: 50%;">
        <div id="chartDiv"></div>
    </div>
    <div id="rightSide" class="fr" style="width:50%; height: 100% ">
        <table class="viewTable">
            <tr>
                <th class="wd5rate">NO</th>
                <th>구분</th>
                <th>아이디</th>
                <th>이름</th>
                <th>나이</th>
                <th>성별</th>
                <th class="wd20rate">등록일시</th>
            </tr>
                <tr class="cursor_pointer itemRow">
                    <td>${resultList.userTypeName}</td>
                    <td>${resultList.userId}</td>
                    <td>${resultList.userName}</td>
                    <td>${resultList.userAge}</td>
                    <td>${resultList.userSexName}</td>
                    <td><fmt:formatDate value="${resultList.regDt}" pattern="yyyy-MM-dd hh:mm:ss"/></td>
                </tr>
        </table>
    </div>
</div>
</body>
</html>
