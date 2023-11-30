<%--
  Created by IntelliJ IDEA.
  User: joyuyeong
  Date: 2021/06/08
  Time: 3:27 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script type="text/javascript">
    var userRegion  = '${statisticTableVO.userRegionDetail}';     //검색조건_지역
    var smellType   = '${statisticTableVO.smellType}';            //검색조건_취기

    $(document).ready(function () {
        if (userRegion != "" && userRegion != null)        { //지역
            $("#searchUserRegion").val(userRegion).prop("selected", true);
        }
        if (smellType != "" &&  smellType != null) {
            $("#smellType").val(smellType).prop("selected", true);
        }


        setButton("statistic");
        $(".statisticTable").each(function () {
            $(this).find(".userRegionMaster").each(function() {
                var rows = $(this).parent().parent().find(".userRegionMaster:contains('" + $(this).text() + "')");
                if (rows.length > 1) {
                    rows.eq(0).attr("rowspan", rows.length);
                    rows.not(":eq(0)").remove();
                }
            });
            $(this).find("td:empty").text("-");
        });
        setDatePicker();

        console.log("searchUserRegion : " + $('#searchUserRegion').val());
        if ($('#searchUserRegion').val() == '') {
            $('#smellType').attr('disabled','disabled');
            $('#smellType').val('').prop('selected',true);
        }

        $("#searchButton").click(function(){
            console.log("click!");
            showLoader(true);
            var searchStart = $("#searchStartSelect").val();
            var searchEnd = $("#searchEndSelect").val();
            var searchUserRegion = $("#searchUserRegion").val();
            var smellType = $("#smellType").val();
            console.log("searchStart : " + searchStart + " , " + "searchEnd : " + searchEnd + " , " + "searchUserRegion : " + searchUserRegion + " , " + "smellType : " + smellType);
            frm.searchStart.value = searchStart;
            frm.searchEnd.value = searchEnd;
            frm.searchUserRegion.value = searchUserRegion;
            frm.smellType.value = smellType;
            document.frm.action = "<c:url value='/statisticSmellTable'/>";
            document.frm.submit();
        });
        $("#resetButton").click(function(){
            showLoader(true);
            $(location).attr('href', '/statisticSmellTable.do');
        });
        //데이터 다운로드 클릭 이벤트
        $("#downloadButton").click(function(){
            setCookie("loading","false");
            checkDownloadCheck();
            showLoader(true);
            var searchStart = $("#searchStartSelect").val();
            var searchEnd = $("#searchEndSelect").val();
            var searchUserRegion = $("#searchUserRegion").val();
            var smellType = $("#smellType").val();
            frm.searchStart.value = searchStart;
            frm.searchEnd.value = searchEnd;
            frm.searchUserRegion.value = searchUserRegion;
            frm.smellType.value = smellType;
            document.frm.action = "<c:url value='/statisticSmellTableDataExcelDownload'/>";
            document.frm.submit();
        });
    });






    function handleChange(e) { // select 박스 handler function
        if (e.id == "searchUserRegion") {
            console.log("e.value : " + e.value);
            if (e.value == '') {
                $('#smellType').attr('disabled', 'disabled');
                $('#smellType').val('').prop('selected', true);
            } else {
                $('#smellType').removeAttr('disabled');
            }
        }
    }

    /*달력 SETTING START*/
    function setDatePicker(){

        $('#searchStartSelect').datepicker();
        $('#searchStartSelect').datepicker("option", "maxDate", $("#searchEndSelect").val());
        $('#searchStartSelect').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchEndSelect").datepicker( "option", "minDate", selectedDate );
        });

        $('#searchEndSelect').datepicker();
        $('#searchEndSelect').datepicker("option", "minDate", $("#searchStartSelect").val());
        $('#searchEndSelect').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchStartSelect").datepicker( "option", "maxDate", selectedDate );
        });
        //datepicker 초기화 END
        //기본값 세팅
        $("#searchStartSelect").val('${statisticTableVO.searchStart}');
        $("#searchEndSelect").val('${statisticTableVO.searchEnd}');
    }



</script>
<body>
<jsp:include page="/menu"/>
<div class="bgc_w wd100rate scrollView fl" style="height: 85%;">
    <form:form id="frm" name="frm" method="post">
        <table class="searchTable">
            <tr>
                <th class="wd90">기간</th>
                <td class="wd20rate">
                    <input type = "hidden" id="searchStart" name="searchStart" value="${statisticTableVO.searchStart}"/>
                    <input type = "hidden" id="searchEnd" name="searchEnd" value="${statisticTableVO.searchEnd}"/>
                    <div class="monthInput">
                        <input type="date" name="startDate" class="mDateTimeInput" id="searchStartSelect" readonly="readonly">
                        ~
                        <input type="date" name="endDate" class="mDateTimeInput" id="searchEndSelect" readonly="readonly">
                    </div>
                </td>
                <th class="wd90">지역</th>
                <td class="wd100">
                    <select id="searchUserRegion" name="userRegionDetail" class="wd90" onchange="handleChange(this)">
                        <option value="">전체</option>
                        <c:forEach var="item" items="${CG_RGD}">
                            <option value="${item.codeId}">${item.codeIdName}</option>
                        </c:forEach>
                    </select>
                </td>
                <th class="wd90">취기</th>
                <td class="wd100">
                    <select id="smellType" name="smellType" class="wd90" onchange="handleChange(this)">
                        <option value="">전체</option>
                        <c:forEach var="item" items="${CG_STY}">
                            <option value="${item.codeId}">${item.codeIdName}</option>
                        </c:forEach>
                    </select>
                </td>
                <td><a class="button resetBtn bgc_grayC mt10 fr" id="resetButton"><i class="bx bx-redo"></i>초기화</a>
                    <a class="button bgcSkyBlue mt10 fr" id="searchButton"><i class="bx bx-search"></i>조회</a>
                    <a class="button bgcDeepBlue mt10 fr" id="downloadButton"><i class="bx bx-download"></i>엑셀</a></td>
            </tr>
        </table>
    </form:form>
    <div  class="dp_inlineBlock borderRight wd100rate">
        <div class="wd100rate" style="overflow: auto; height: 100%;">
            <c:choose>
                <c:when test="${userRegionDetail eq '' || userRegionDetail eq null}">
                    <table class="statisticTable" style="width: 65% !important;">
                        <caption class="statisticSmellTableCaption">&lt;주민 악취모니터링 주요 취기 결과&gt;</caption>
                        <th colspan="3" class="">구분</th>
                        <th class="">돈사취</th>
                        <th class="">계사취</th>
                        <th class="">우사취</th>
                        <th class="">액비</th>
                        <th class="">퇴비</th>
                        <th class="">음식물</th>
                        <th class="">자숙</th>
                        <th class="">기타냄새</th>
                        <c:forEach items="${resultList}" begin="1" end="1">
                            <tr>
                                <td colspan="2">계</td>
                                <td class="">${resultList.totalCount}</td>
                                <td class="">${resultList.pigSmell}</td>
                                <td class="">${resultList.chikenSmell}</td>
                                <td class="">${resultList.cowSmell}</td>
                                <td class="">${resultList.waterCompostSmell}</td>
                                <td class="">${resultList.compostSmell}</td>
                                <td class="">${resultList.foodSmell}</td>
                                <td class="">${resultList.steamSmell}</td>
                                <td class="">${resultList.otherSmell}</td>
                            </tr>
                        </c:forEach>
                        <c:forEach items="${resultListDetail}" var="result" varStatus="status">
                            <tr>
                                <td class="userRegionMaster">${result.userRegionMasterName}</td>
                                <td class="">${result.userRegionDetailName}</td>
                                <td class="">${result.totalCount}</td>
                                <td class="">${result.pigSmell}</td>
                                <td class="">${result.chikenSmell}</td>
                                <td class="">${result.cowSmell}</td>
                                <td class="">${result.waterCompostSmell}</td>
                                <td class="">${result.compostSmell}</td>
                                <td class="">${result.foodSmell}</td>
                                <td class="">${result.steamSmell}</td>
                                <td class="">${result.otherSmell}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:when>
                <c:otherwise>
                    <table class="statisticTable" style="width: 65% !important;">
                                <caption class="statisticSmellTableCaption">&lt; ${userRegion.codeIdName}-주민 악취모니터링 결과&gt;</caption>
                            <tr>
                                <th rowspan="2">구분</th>
                                <th rowspan="2">총<br>입력횟수</th>
                                <th rowspan="2">악취<br>감지횟수</th>
                                <th rowspan="2">악취감지비율</th>
                                <th colspan="5">악취강도</th>
                            </tr>
                            <tr>
                                <th>1도</th>
                                <th>2도</th>
                                <th>3도</th>
                                <th>4도</th>
                                <th>5도</th>
                            </tr>
                        <c:forEach items="${resultListByRegion}" var="resultByRegion" varStatus="status">
                            <c:if test="${resultByRegion.registerTime ne '합계' && status.first}">
                                <tr>
                                    <td>합계</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                </tr>
                            </c:if>
                            <tr>
                                <c:choose>
                                    <c:when test="${resultByRegion.registerTime eq '합계'}">
                                        <td>${resultByRegion.registerTime}</td>
                                    </c:when>
                                    <c:when test="${resultByRegion.registerTime eq '06:00 ~ 09:00'}">
                                        <td>오전<br>${resultByRegion.registerTime}</td>
                                    </c:when>
                                    <c:when test="${resultByRegion.registerTime eq '11:00 ~ 17:00'}">
                                        <td>오후<br>${resultByRegion.registerTime}</td>
                                    </c:when>
                                    <c:otherwise>
                                        <td>야간<br>${resultByRegion.registerTime}</td>
                                    </c:otherwise>
                                </c:choose>

                                <td>${resultByRegion.userReg}</td>
                                <td>${resultByRegion.totalUserRegSmell}</td>
                                <td>${resultByRegion.smellPercentage}%</td>
                                <td>${resultByRegion.smellLevel1}</td>
                                <td>${resultByRegion.smellLevel2}</td>
                                <td>${resultByRegion.smellLevel3}</td>
                                <td>${resultByRegion.smellLevel4}</td>
                                <td>${resultByRegion.smellLevel5}</td>
                            </tr>
                        </c:forEach>
                    </table>
                    <table class="statisticTable" style="width: 65% !important;">
                        <caption class="statisticSmellTableCaption">&lt; ${userRegion.codeIdName}-주요 취기별 악취강도(회)&gt;</caption>
                        <tr>
                            <th rowspan="2" colspan="2">구분</th>
                            <th colspan="5">악취강도</th>
                        </tr>
                        <tr>
                            <th>1도</th>
                            <th>2도</th>
                            <th>3도</th>
                            <th>4도</th>
                            <th>5도</th>
                        </tr>
                        <c:forEach items="${resultListByRegionDetail}" var="resultListByRegionDetail" varStatus="status">
                            <c:if test="${resultListByRegionDetail.smellType ne '합계' && status.first}">
                                <tr>
                                    <td>합계</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                </tr>
                            </c:if>
                            <tr>
                                <td>${resultListByRegionDetail.smellType}</td>
                                <td>${resultListByRegionDetail.totalUserRegSmell}</td>
                                <td>${resultListByRegionDetail.smellLevel1}</td>
                                <td>${resultListByRegionDetail.smellLevel2}</td>
                                <td>${resultListByRegionDetail.smellLevel3}</td>
                                <td>${resultListByRegionDetail.smellLevel4}</td>
                                <td>${resultListByRegionDetail.smellLevel5}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
