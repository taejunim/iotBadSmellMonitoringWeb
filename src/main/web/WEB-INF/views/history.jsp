<%--
  Created by IntelliJ IDEA.
  User: guava
  Date: 2021/06/03
  Time: 10:04 오전
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script type="text/javascript">

        $(document).ready(function () {
            setButton("history");
            setDatePicker();

            var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
            var options = { //지도를 생성할 때 필요한 기본 옵션
                center: new kakao.maps.LatLng(33.450701, 126.570667), //지도의 중심좌표.
                level: 3 //지도의 레벨(확대, 축소 정도)
            };

            var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
        });
        function setDatePicker(){

            //datepicker 초기화 START
            $('#datePicker').datepicker();

            /*    $('#searchStartDt').datepicker("option", "maxDate", $("#searchEndDt").val());
                $('#searchStartDt').datepicker("option", "onClose", function ( selectedDate ) {
                  $("#searchEndDt").datepicker( "option", "minDate", selectedDate );
                });

                $('#searchEndDt').datepicker();
                $('#searchEndDt').datepicker("option", "minDate", $("#searchStartDt").val());
                $('#searchEndDt').datepicker("option", "onClose", function ( selectedDate ) {
                  $("#searchStartDt").datepicker( "option", "maxDate", selectedDate );
                });*/
            //datepicker 초기화 END
        }

</script>
<body>
<jsp:include page="/menu"/>
<table class="searchTable">
    <tr>
        <th>등록자</th><td><input type="text" ></td>
        <th>등록일</th><td><input type="date" class="mDateTimeInput" id="datePicker" readonly="readonly"></td>
        <th>취기</th><td><select><option>전체</option><option>구린 냄새</option><option>음식물 냄새</option><option>고무 냄새</option><option>가스 냄새</option><option>페인트 냄새</option><option>사료 냄새</option></select></td>
        <th>악취 강도</th><td><select><option>전체</option><option>(0)무취</option><option>(1)감지 취기</option><option>(2)보통 취기</option><option>(3)강한 취기</option><option>(4)극심한 취기</option><option>(5)참기 어려운 취기</option></select></td>
        <th>기상 상태</th><td><select><option>전체</option><option>날씨</option><option>기온</option><option>습도</option><option>풍향</option><option>풍속</option></select></td>
        <td><a class="button bgcSkyBlue mt10 fr"><i class="bx bx-search"></i>조회</a></td>
    </tr>
</table>
<div class="wd100rate h100rate bgc_w">

    <div class="wd70rate h100rate fl brDeepBlue">
        <table class=" viewTable">
            <tr>
                <th class="wd5rate">NO</th>
                <th>기상 상태</th>
                <th>접수 시간대</th>
                <th>악취 강도</th>
                <th>취기</th>
                <th>등록자</th>
                <th class="wd20rate">등록일시</th>
            </tr>
            <tr>
                <td>1</td>
                <td>맑음</td>
                <td>20:00~22:00</td>
                <td>(5)참기 어려운 취기</td>
                <td>고무 냄새</td>
                <td>이름1</td>
                <td>2021-05-28 21:56:00</td>
            </tr>
            <tr>
                <td>2</td>
                <td>비</td>
                <td>12:00~14:00</td>
                <td>(1)감지 취기</td>
                <td>음식물 냄새</td>
                <td>이름1</td>
                <td>2021-05-28 21:56:00</td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
        </table>
        <hr id="pageline" class="wd95rate">
        <div id="pagination" class="pagingBox align_c">
            <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page"/>
        </div>
    </div>

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
                    <td>맑음</td>
                </tr>
                <tr>
                    <td class="font_bold">등록자</td>
                    <td>이름4</td>
                    <td class="font_bold">등록자 아이디</td>
                    <td>test1234</td>
                </tr>
                <tr>
                    <td class="font_bold">취기</td>
                    <td>고무냄새</td>
                    <td class="font_bold">악취 강도</td>
                    <td>감지 취기(1)</td>
                </tr>
                <tr>
                    <td class="font_bold">기상 상태</td>
                    <td>이름4</td>
                    <td class="font_bold">온도</td>
                    <td>test1234</td>
                </tr>
                <tr>
                    <td class="font_bold">풍향</td>
                    <td>이름4</td>
                    <td class="font_bold">풍속</td>
                    <td>test1234</td>
                </tr>
                <tr>
                    <td colspan="2" class="font_bold">등록일시</td>
                    <td colspan="2">2021-05-28 21:56:00</td>
                </tr>
                <tr class="h200">
                    <td colspan="1" class="font_bold" id="">비고</td>
                    <td colspan="3">
                        냄새가 났당 말았당 햄수다..<br>
                        제기 봐줍서양!
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
