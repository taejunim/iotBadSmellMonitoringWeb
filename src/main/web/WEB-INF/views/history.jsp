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
var smellRegisterNo;

var regId = '${historyVO.regId}';               //검색조건_등록자/등록자 아이디
var startDate = '${historyVO.startDate}';       //검색조건_등록일 시작
var endDate = '${historyVO.endDate}';           //검색조건_등록일 끝
var smellType = '${historyVO.smellType}';       //검색조건_취기
var smellValue = '${historyVO.smellValue}';     //검색조건_악취 강도
var weatherState = '${historyVO.weatherState}'; //검색조건_기상 상태

        $(document).ready(function () {

            setButton("history");                   //선택된 화면의 메뉴색 변경 CALL.
            setDatePicker();                        //달력 SETTING CALL.

             //지도 기본 설정 -> 금악리로 중심 잡아둠, Zoom Level 5
             map = focusMapCenter(33.352974, 126.314419, 5);

            /* 검색 화면 검색어 세팅 START*/
            //시작날짜
            if (startDate != "" && startDate != null)
                $("#searchStartDt").val(startDate).prop("selected", true);

            //종료날짜
            if (endDate != "" && endDate != null)
                $("#searchEndDt").val(endDate).prop("selected", true);

            //취기
            if (smellType != "" && smellType != null)
                $("#smellType").val(smellType).prop("selected", true);                              //VO 값 선택

            //악취강도
            if (smellValue != "" && smellValue != null)
                $("#smellValue").val(smellValue).prop("selected", true);                              //VO 값 선택

            //기상상태
            if (weatherState != "" && weatherState != null)
                $("#weatherState").val(weatherState).prop("selected", true);
            /* 검색 화면 검색어 세팅 END*/

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

            /* 테이블 row 클릭 이벤트 START*/
            $(".itemRow").click( function () {

                $(this).css('background-color', 'rgb(217,239,255)');                        //선택된 로우 색상 변경
                $(".itemRow").not($(this)).css('background-color', 'rgba(255,255,255,0)');  //선택되지 않은 로우 색상


                /*오른쪽 table에 값 담아주기 START*/
                var getItems = $(this).find("td");  //viewTable의 row

                $("#getWeatherState").text(getItems.eq(1).text());              //기상 상태
                $("#getRegId").text(getItems.eq(8).text());                     //등록자 아이디
                $("#getRegName").text(getItems.eq(9).text());                   //등록자
                $("#getSmellType").text(getItems.eq(4).text());                 //취기
                $("#getSmellValue").text(getItems.eq(3).text());                //악취 강도
                $("#humidityValue").text(getItems.eq(11).text() + "%");          //습도
                $("#getTemperatureValue").text(getItems.eq(12).text() + " ℃");   //온도
                $("#getWindDirectionValue").text(getItems.eq(13).text());       //풍향
                $("#getWindSpeedValue").text(getItems.eq(14).text() +"m/s");    //풍속
                $("#getRegDt").text(getItems.eq(10).text());                     //등록일시
                $("#smellComment").text(getItems.eq(15).text());                //비고
                /*오른쪽 table에 값 담아주기 END*/

                /*지도 세팅 START*/
                var gpsX = getItems.eq(16).text();       //gps_x의 값
                var gpsY = getItems.eq(17).text();       //gps_y의 값

                var mapContainer = document.getElementById('map'), // 지도를 표시할 div
                    mapOption = {
                        center: new kakao.maps.LatLng(gpsY, gpsX), // 지도의 중심좌표
                        level: 5 // 지도의 확대 레벨
                    };
                var map = new kakao.maps.Map(mapContainer, mapOption); // 지도 생성

                var markerPosition  = new kakao.maps.LatLng(gpsY, gpsX); // 마커가 표시될 위치

                var smellValue = getItems.eq(3).text();     //returnMarkerImage에 넘겨줄 파라미터

                var markerImage = returnMarkerImage(smellValue); //마커 이미지

                // 마커를 생성합니다
                var marker = new kakao.maps.Marker({
                    map: map, // 마커를 표시할 지도
                    position: markerPosition, // 마커를 표시할 위치
                    image: markerImage // 마커 이미지
                });
                // 마커가 지도 위에 표시되도록 설정
                marker.setMap(map);
                /*지도 세팅 END*/

                /*이미지 불러오기 START*/
                smellRegisterNo =  getItems.eq(15).text()  //table의 resultList로 받아온 smellRegisterNo 가져오기

                fn_img_list(); //이미지 불러오기 함수
                /*이미지 불러오기 END*/
            });
            /* 테이블 row 클릭 이벤트 END*/

            //이미지 삭제 클릭 이벤트
            $(document).on("click",".deleteButton",function(){
                var index = $(this).attr('id').replaceAll("imageDeleteBtn","");  //viewTable의 row
                imageDelete(index); //이미지 삭제 함수
            });

            //데이터 다운로드 클릭 이벤트
            $("#downloadButton").click(function(){

                document.frm.action = "<c:url value='/historyDataExcelDownload'/>";
                document.frm.submit();
            });

        });

//이미지 호출 AJAX
function fn_img_list(){

    $.ajax({
        url: "/imageListSelect",
        type: "GET",
        data:{smellRegisterNo : smellRegisterNo},
        dataType: "json",
        cashe : false,
        success: function (data) {

            if (data.length == 0) {         //해당 조건에 데이터가 없을 때
                $("#getImage").html("-해당 이미지가 존재하지 않습니다.-");
            } else {                       //데이터가 있을 때
                $("#getImage").html("");
                getImage(data);             //이미지 호출 함수
            }
        },
        error: function (err) {
            alert("이미지 데이터를 불러오는중 에러가 발생하였습니다.");
        }
    });
}

//이미지 가져와서 보여주기
function getImage(images) {

    var str = "";

    for (var i = 0; i < images.length; i++) {

        var image = images[i];

        str += '<tr>'
        str += '<td id="getImage" colspan="4">';
        str += '<img src="' + image.smellImagePath + '" width="460" height="200"/>';                        //이미지 경로
        str += '<input type="hidden" id = "smellImageNo' + i + '" value = "' + image.smellImageNo + '"/>';  //이미지 번호
        str += '<input type="hidden" id = "smellImagePath' + i + '" value = "' + image.smellImagePath + '"/>';  //이미지 경로
        str += '<input type="hidden" id = "smellOriginalPath' + i + '" value = "' + image.smellOriginalPath + '"/>';  //이미지 오리지널 경로
        str += '</td>';
        str += '<td colspan="1"><a class="subButton deleteButton" type="button" id="imageDeleteBtn' + i + '">이 미 지 삭 제</a></td>';        //삭제 버튼
        str += '</tr>'
    }
    var $getImage = $("#getImage")
    $getImage.append(str);
}

//이미지 삭제 함수
function imageDelete(imageIndex){

    var con_test = confirm("이미지를 삭제하시겠습니까?");  //이미지 삭제 허가 요청

    if(con_test == true){ //이미지 삭제 허용 시

        var getImageNo =  $("#smellImageNo" + imageIndex).val(); //이미지 번호
        var getImagePath =  $("#smellImagePath" + imageIndex).val(); //이미지 경로
        var getOriginalPath =  $("#smellOriginalPath" + imageIndex).val(); //이미지 오리지널 경로

        $.ajax({
            url: "/historyImgDelete/",
            type: "GET",
            data: {
                smellImageNo: getImageNo,
                smellRegisterNo: smellRegisterNo,
                smellImagePath: getImagePath,
                smellOriginalPath: getOriginalPath
            },
            dataType: "text",
            success: function (data) {
                alert("이미지를 삭제하였습니다.");
                fn_img_list();   //이미지 불러오기 함수
            },
            error: function (err) {
                alert("이미지 삭제를 실패하였습니다.");
                console.log(err);
            }
        });
    }
}

        //페이지 이동 스크립트
        function fn_page(pageNo) {
            showLoader(true);
            //vo에 담긴 값이 입력된 값과 다를 경우 강제로 vo에 담긴 값을 form에 넣어주기
            if (regId !=  $("#registerName")){
                frm.regId.value = regId;
            }
            if (startDate !=  $("#searchStartDt")){
                frm.startDate.value = startDate;
            }
            if (endDate !=  $("#searchEndDt")){
                frm.endDate.value = endDate;
            }
            if (smellType !=  $("#smellType")){
                frm.smellType.value = smellType;
            }
            if (smellValue !=  $("#smellValue")){
                frm.smellValue.value = smellValue;
            }
            if (weatherState !=  $("#weatherState")){
                frm.weatherState.value = weatherState;
            }
            frm.pageIndex.value = pageNo;
            document.frm.action = "<c:url value='/history.do'/>";
            document.frm.submit();
        }

        //조회
        function fn_search() {
            showLoader(true);
            frm.pageIndex.value = 1;
            document.frm.action = "<c:url value='/history.do'/>";
            document.frm.submit();
        }

        //초기화
        function fn_reset() {
            showLoader(true);
            $("#registerName").val("");
            $("#searchStartDt").val("");
            $("#searchEndDt").val("");
            $("#smellType").val("");
            $("#smellValue").val("");
            $("#weatherState").val("");

            frm.pageIndex.value = 1;
            document.frm.action = "<c:url value='/history.do'/>";
            document.frm.submit();
        }
</script>
<body>
<jsp:include page="/menu"/>
<div class="wd100rate h100rate bgc_w scrollView">
<table class="searchTable">

    <form:form id="frm" name="frm" method="post">
    <input type="hidden" id="pageIndex" name="pageIndex" value="${historyVO.pageIndex}">
    <tr>
        <th>등록자/등록자 아이디</th>
        <td><input type="text" id="registerName" name="regId" value="${historyVO.regId}" class="wd100"></td>
        <th class="wd60">등록일</th>
            <td>
        <input type="date" name="startDate" class="mDateTimeInput" value="${historyVO.startDate}" id="searchStartDt" readonly="readonly">
        ~
        <input type="date" name="endDate" class="mDateTimeInput" value="${historyVO.endDate}" id="searchEndDt" readonly="readonly">
            </td>
        <th class="wd50">취기</th>
        <td>
            <select id="smellType" name="smellType" class="wd90">
                <option value="">전체</option>
                <c:forEach var="item" items="${CG_STY}">
                    <option value="${item.codeId}">${item.codeIdName}</option>
                </c:forEach>
            </select>
        </td>
        <th>악취 강도</th>
        <td><select id="smellValue" name="smellValue" class="wd150">
            <option value="">전체</option>
                <c:forEach var="item" items="${CG_SMT}">
                    <option value="${item.codeId}">${item.codeIdName}</option>
                </c:forEach>
        </select></td>
        <th>기상 상태</th>
        <td><select id="weatherState" name="weatherState" class="wd120">
            <option value="">전체</option>
                <c:forEach var="item" items="${CG_WET}">
                    <option value="${item.codeId}">${item.codeIdName}</option>
                </c:forEach>
        </select></td>
        <td><a class="button resetBtn bgc_grayC mt10 fr" onclick="fn_reset();"><i class="bx bx-redo"></i>초기화</a>
            <a class="button bgcSkyBlue mt10 fr" onclick="fn_search();"><i class="bx bx-search"></i>조회</a>
            <a class="button bgcDeepBlue mt10 fr" id="downloadButton"><i class="bx bx-download"></i>엑셀</a></td>
    </tr>
</table>
<div class="wd100rate h100rate bgc_w scrollView">
    <div class="wd70rate h100rate fl brDeepBlue">
        <table class=" viewTable font_size13">
            <tr>
                <th class="wd5rate">NO</th>
                <th>기상 상태</th>
                <th>접수 시간대</th>
                <th>악취 강도</th>
                <th>취기</th>
                <th>미세먼지</br>측정소명/장치ID</th>
                <th>PM10 미세먼지</br>평균 값 (㎍/㎥)</th>
                <th>미세먼지 데이터</br>수집일시</th>
                <th class="wd10rate">등록자 아이디</th>
                <th class="wd10rate">등록자</th>
                <th class="wd15rate">등록일시</th>
            </tr>
            <c:forEach var="resultList" items="${resultList}" varStatus="status">
            <tr class="cursor_pointer itemRow" id="tr-hover">
                <td>${paginationInfo.totalRecordCount - ((historyVO.pageIndex-1) * 10) - status.index}</td>
                <td>${resultList.weatherStateName}</td>
                <td>${resultList.smellRegisterTimeName}</td>
                <td>${resultList.smellValueName}</td>
                <td>${resultList.smellTypeName}</td>
                <td>${resultList.airSensorName}</td>
                <td>${resultList.pm10Avg}</td>
                <td>${resultList.airSensingDate}</td>
                <td>${resultList.regId}</td>
                <td>${resultList.userName}</td>
                <td>${resultList.regDt}</td>
                <td style="display:none;">${resultList.humidityValue}</td>
                <td style="display:none;">${resultList.temperatureValue}</td>
                <td style="display:none;">${resultList.windDirectionValueName}</td>
                <td style="display:none;">${resultList.windSpeedValue}</td>
                <td style="display:none;">${resultList.smellComment}</td>
                <td style="display:none;">${resultList.gpsX }</td>
                <td style="display:none;">${resultList.gpsY}</td>
                <td style="display:none;">${resultList.smellRegisterNo}</td>
            </tr>
            </c:forEach>
            <c:if test="${empty resultList}">
                <tr>
                    <td align="center" colspan="11" rowspan="10">- 해당 데이터가 존재하지 않습니다. -</td>
                </tr>
            </c:if>
            <c:if test="${!empty resultList && resultList.size() ne 10}">
                <tr style="background-color: rgba(255,255,255,0)">
                    <td align="center" colspan="11" rowspan="${10-resultList.size()}"></td>
                </tr>
            </c:if>
        </table>
        <div id="pagination" class="pagingBox align_c">
            <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page"/>
        </div>
    </div>

    <div class="scrollView">
        <div id="rightSide" class="fr wd100rate h40rate">
            <table class="border_none mg0auto wd90rate mb20">
                <tr>
                    <td><div class="mapLegendSmall bgcSkyBlue"></div><label class="mapLegendLabelSmall">${CG_SMT[0].codeIdName}</label></td>
                    <td><div class="mapLegendSmall bgcLightGreen"></div><label class="mapLegendLabelSmall">${CG_SMT[1].codeIdName}</label></td>
                    <td><div class="mapLegendSmall bgcWhite"></div><label class="mapLegendLabelSmall">${CG_SMT[2].codeIdName}</label></td>
                </tr>
                <tr>
                    <td><div class="mapLegendSmall bgcYellow"></div><label class="mapLegendLabelSmall">${CG_SMT[3].codeIdName}</label></td>
                    <td><div class="mapLegendSmall bgcOrange"></div><label class="mapLegendLabelSmall">${CG_SMT[4].codeIdName}</label></td>
                    <td><div class="mapLegendSmall bgcDeepRed"></div><label class="mapLegendLabelSmall">${CG_SMT[5].codeIdName}</label></td>
                </tr>
            </table>
            <div id="map" class="wd90rate h80rate" style="margin:auto;"></div>
            <div>
                <table class="wd90rate secondViewTable" >
                    <tr>
                        <td class="font_bold">날씨</td>
                        <td colspan="3" id="getWeatherState"></td>
                    </tr>
                    <tr>
                        <td class="font_bold">등록자</td>
                        <td id="getRegName"> </td>
                        <td class="font_bold">등록자 아이디</td>
                        <td id="getRegId" name="redID"> </td>
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
                        <td class="font_bold">풍향</td>
                        <td id="getWindDirectionValue" ></td>
                        <td class="font_bold">풍속</td>
                        <td id="getWindSpeedValue" ></td>
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
                    <tr class="h200" id="test">
                        <td colspan="4" id="getImage">
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form:form>
</div>
</body>
</html>