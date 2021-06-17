<%--
  Created by IntelliJ IDEA.
  User: guava
  Date: 2021/06/03
  Time: 10:04 오전
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script src="/resources/js/kakaoMapUtils.js"></script>
<script type="text/javascript">
var map;
        $(document).ready(function () {

            setButton("history");                   //선택된 화면의 메뉴색 변경 CALL.
            setDatePicker();                        //달력 SETTING CALL.

             //지도 기본 설정 -> 금악리로 중심 잡아둠, Zoom Level 5
             map = focusMapCenter(33.352974, 126.314419, 5);

            /* 검색 화면 검색어 세팅 START*/
            var startDate = '${historyVO.startDate}';          //시작날짜

            if (startDate != "" && startDate != null)
                $("#searchStartDt").val(startDate).prop("selected", true);
            var endDate = '${historyVO.endDate}';              //종료날짜 

            if (endDate != "" && endDate != null)
                $("#searchEndDt").val(endDate).prop("selected", true);
            var smellType = '${historyVO.smellType}';          //취기

            if (smellType != "" && smellType != null)
                $("#smellType").val(smellType).prop("selected", true);                              //VO 값 선택

            var smellValue = '${historyVO.smellValue}';        //악취강도

            if (smellValue != "" && smellValue != null)
                $("#smellValue").val(smellValue).prop("selected", true);                              //VO 값 선택

            var weaterState = '${historyVO.weaterState}';       //기상상태

            if (weaterState != "" && weaterState != null)
                $("#weaterState").val(weaterState).prop("selected", true);
            /* 검색 화면 검색어 세팅 END*/

            // 테이블 row 클릭 이벤트
            $(".itemRow").click(function () {

                var getItems = $(this).find("td");  //viewTable의 row

                $("#getWeaterState").text(getItems.eq(1).text());
                $("#getRegName").text(getItems.eq(5).text());
                $("#getRegId").text(getItems.eq(7).text());
                $("#getSmellType").text(getItems.eq(4).text());
                $("#getSmellValue").text(getItems.eq(3).text());
                $("#humidityValue").text(getItems.eq(8).text() + "%");
                $("#getTemperatureValue").text(getItems.eq(9).text() + " ℃");
                $("#getWindDirectionValue").text(getItems.eq(10).text());
                $("#getWindSpeedValue").text(getItems.eq(11).text() +"m/s");
                $("#getRegDt").text(getItems.eq(6).text());
                $("#smellComment").text(getItems.eq(12).text());

                /*지도 세팅 START*/
                var gpsX = getItems.eq(13).text();       //gps_x의 값
                var gpsY = getItems.eq(14).text();       //gps_y의 값
                var mapContainer = document.getElementById('map'), // 지도를 표시할 div
                    mapOption = {
                        center: new kakao.maps.LatLng(gpsY, gpsX), // 지도의 중심좌표
                        level: 3 // 지도의 확대 레벨
                    };
                var map = new kakao.maps.Map(mapContainer, mapOption); // 지도 생성
                // 마커가 표시될 위치
                var markerPosition  = new kakao.maps.LatLng(gpsY, gpsX);
                // 마커 생성
                var marker = new kakao.maps.Marker({
                    position: markerPosition
                });
                // 마커가 지도 위에 표시되도록 설정
                marker.setMap(map);
                /*지도 세팅 END*/


            })
        });

        //달력 SETTING
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

        //페이지 이동 스크립트
        function fn_page(pageNo) {
            frm.pageIndex.value = pageNo;
            document.frm.action = "<c:url value='/history.do'/>";
            document.frm.submit();
        }

        //조회
        function fn_search() {
            console.log("조회 버튼 클릭");
            frm.pageIndex.value = 1;
            document.frm.action = "<c:url value='/history.do'/>";
            document.frm.submit();
        }
</script>
<body>
<jsp:include page="/menu"/>

<table class="searchTable">

    <form:form id="frm" name="frm" method="post">
    <input type="hidden" id="pageIndex" name="pageIndex" value="${historyVO.pageIndex}">
    <tr>
        <th>등록자</th>
        <td><input type="text" name="regId" value="${historyVO.regId}"></td>
        <th>등록일</th>
            <td>
        <input type="date" name="startDate" class="mDateTimeInput" value="${historyVO.startDate}" id="searchStartDt" readonly="readonly">
        ~
        <input type="date" name="endDate" class="mDateTimeInput" value="${historyVO.endDate}" id="searchEndDt" readonly="readonly">
            </td>
        <th>취기</th>
        <td>
            <select id="smellType" name="smellType">
                <option value="">전체</option>
                <c:forEach var="item" items="${CG_STY}">
                    <option value="${item.codeId}">${item.codeIdName}</option>
                </c:forEach>
            </select>
        </td>
        <th>악취 강도</th>
        <td><select id="smellValue" name="smellValue">
            <option value="">전체</option>
                <c:forEach var="item" items="${CG_SMT}">
                    <option value="${item.codeId}">${item.codeIdName}</option>
                </c:forEach>
        </select></td>
        <th>기상 상태</th>
        <td><select id="weaterState" name="weaterState">
            <option value="">전체</option>
                <c:forEach var="item" items="${CG_WET}">
                    <option value="${item.codeId}">${item.codeIdName}</option>
                </c:forEach>
        </select></td>
        <td><a class="button resetBtn"></a></td>
        <td><a class="button bgcSkyBlue mt10 fr" onclick="fn_search();"><i class="bx bx-search"></i>조회</a></td>
    </tr>
</table>
<div class="wd100rate h100rate bgc_w scrollView">

    <div class="wd70rate h100rate fl brDeepBlue">
        <table class=" viewTable font_size15">
            <tr>
                <th class="wd5rate">NO</th>
                <th>기상 상태</th>
                <th>접수 시간대</th>
                <th>악취 강도</th>
                <th>취기</th>
                <th>등록자</th>
                <th class="wd20rate">등록일시</th>
            </tr>
            <c:forEach var="resultList" items="${resultList}" varStatus="status">
            <tr class="cursor_pointer itemRow">
                <td>${paginationInfo.totalRecordCount - ((historyVO.pageIndex-1) * 10) - status.index}</td>
                <td>${resultList.weaterStateName}</td>
                <td>${resultList.smellRegisterTimeName}</td>
                <td>${resultList.smellValueName}</td>
                <td>${resultList.smellTypeName}</td>
                <td>${resultList.regId}</td>
                <td>${resultList.regDt }</td>
                <td style="display:none;">${resultList.userName}</td>
                <td style="display:none;">${resultList.humidityValue}</td>
                <td style="display:none;">${resultList.temperatureValue}</td>
                <td style="display:none;">${resultList.windDirectionValueName}</td>
                <td style="display:none;">${resultList.windSpeedValue}</td>
                <td style="display:none;">${resultList.smellComment}</td>
                <td style="display:none;">${resultList.gpsX }</td>
                <td style="display:none;">${resultList.gpsY}</td>
            </tr>
            </c:forEach>
            <c:if test="${empty resultList}">
                <tr>
                    <td align="center" colspan="7" rowspan="10">- 해당 데이터가 존재하지 않습니다. -</td>
                </tr>
            </c:if>
            <c:if test="${!empty resultList && resultList.size() ne 10}">
                <tr>
                    <td align="center" colspan="7" rowspan="${10-resultList.size()}"></td>
                </tr>
            </c:if>
        </table>
        <div id="pagination" class="pagingBox align_c">
            <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page"/>
        </div>
    </div>
    </form:form>
    <div class="scrollView">
        <div id="rightSide" class="fr wd100rate h50rate">
            <div id="map" class="wd100rate h100rate"></div>
        </div>
        <p style="color: white">a</p>
        <div>
            <table class="wd80rate secondViewTable" >
                <p></p>
                <tr>
                    <td class="font_bold">날씨</td>
                    <td id="getWeaterState"></td>
                </tr>
                <tr>
                    <td  class="font_bold">등록자</td>
                    <td  id="getRegName"> </td>
                    <td  class="font_bold">등록자 아이디</td>
                    <td  id="getRegId" name="redID"> </td>
                </tr>
                <tr>
                    <td class="font_bold">취기</td>
                    <td id="getSmellType"> </td>
                    <td class="font_bold">악취 강도</td>
                    <td id="getSmellValue"> </td>
                </tr>
                <tr>
                    <td class="font_bold">습도</td>
                    <td id="humidityValue" ></td>
                    <td class="font_bold">온도</td>
                    <td id="getTemperatureValue" ></td>
                </tr>
                <tr>
                    <td colspan="1" class="font_bold">풍향</td>
                    <td colspan="1" id="getWindDirectionValue" ></td>
                    <td colspan="1" class="font_bold">풍속</td>
                    <td colspan="1" id="getWindSpeedValue" ></td>
                </tr>
                <tr>
                    <td colspan="1" class="font_bold">등록일시</td>
                    <td colspan="3" id="getRegDt" ></td>
                </tr>
                <tr class="h200">
                    <td colspan="1" class="font_bold" id="">비고</td>
                    <td colspan="3" id="smellComment">
                    </td>
                </tr>
                <tr class="h200">
                    <td colspan="3">이미지</td>
                    <td colspan="1"><a class="subButton">이미지 삭제</a></td>
                </tr>
                <tr class="h200">
                    <td colspan="3">이미지</td>
                    <td colspan="1"><a class="subButton">이미지 삭제</a></td>
                </tr>
            </table>
        </div>
    </div>
</div>
</body>
</html>
