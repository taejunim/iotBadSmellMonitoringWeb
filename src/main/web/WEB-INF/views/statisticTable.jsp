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
    $(document).ready(function () {
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

        $("#searchButton").click(function(){
            showLoader(true);
            var searchStart = $("#searchStartSelect").val();
            var searchEnd = $("#searchEndSelect").val();
            frm.searchStart.value = searchStart;
            frm.searchEnd.value = searchEnd;
            document.frm.action = "<c:url value='/statisticTable'/>";
            document.frm.submit();
        });
        $("#resetButton").click(function(){
            showLoader(true);
            $(location).attr('href', '/statisticTable.do');
        });
        //데이터 다운로드 클릭 이벤트
        $("#downloadButton").click(function(){
            setCookie("loading","false");
            checkDownloadCheck();
            showLoader(true);
            document.frm.action = "<c:url value='/statisticTableDataExcelDownload'/>";
            document.frm.submit();
        });

        setDatePicker();

    });

    /*달력 SETTING START*/
    function setDatePicker(){

        $('#searchStartSelect').datepicker();
        $('#searchStartSelect').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchEndSelect").datepicker( "option", "minDate", selectedDate );

            var date = new Date(selectedDate);
            date = new Date(date.getFullYear() + "-12-31");
            $("#searchEndSelect").datepicker( "option", "maxDate", date );
        });

        $('#searchEndSelect').datepicker();
        $('#searchEndSelect').datepicker("option", "onClose", function ( selectedDate ) {
            //$("#searchStartDt").datepicker( "option", "maxDate", selectedDate );
        });
        //datepicker 초기화 END
        //기본값 세팅
        $("#searchStartSelect").val('${statisticTableVO.searchStart}');
        $("#searchEndSelect").val('${statisticTableVO.searchEnd}');
    }
    /*달력 SETTING END*/

</script>
<body>
<jsp:include page="/menu"/>
<div class="bgc_w wd100rate scrollView fl" style="height: 85%;">
    <form:form id="frm" name="frm" method="post">
        <table class="searchTable">
            <tr>
                <th class="wd90">기간</th>
                <td>
                    <input type = "hidden" id="searchStart" name="searchStart" value="${statisticTableVO.searchStart}"/>
                    <input type = "hidden" id="searchEnd" name="searchEnd" value="${statisticTableVO.searchEnd}"/>
                    <div class="monthInput">
                        <input type="date" name="startDate" class="mDateTimeInput" id="searchStartSelect" readonly="readonly">
                        ~
                        <input type="date" name="endDate" class="mDateTimeInput" id="searchEndSelect" readonly="readonly">
                    </div>
                </td>
                <td><a class="button resetBtn bgc_grayC mt10 fr" id="resetButton"><i class="bx bx-redo"></i>초기화</a>
                    <a class="button bgcSkyBlue mt10 fr" id="searchButton"><i class="bx bx-search"></i>조회</a>
                    <a class="button bgcDeepBlue mt10 fr" id="downloadButton"><i class="bx bx-download"></i>엑셀</a></td>
            </tr>
        </table>
    </form:form>
    <div  class="dp_inlineBlock borderRight wd100rate">
        <div class="wd100rate" style="overflow: auto;">
            <c:forEach var="item" items="${resultList}" varStatus="status">
                <c:set var="result" value="${resultList.get(status.index)}"/>
                <div class="wd50rate fl p_re pt20">
                    <Label for = "table${status.index}" class="statisticTableLabel">* 주민 참여형 악취 모니터링 결과 (접수 시간대 -
                        <c:choose>
                            <c:when test="${result.smellRegisterTimeName ne ''}">${result.smellRegisterTimeName}</c:when>
                            <c:otherwise>전체</c:otherwise>
                        </c:choose>
                    )</Label>
                    <table id="table${status.index}" class="statisticTable">
                        <thead>
                            <tr>
                                <th colspan="2" class="statisticTableVerticalTh">구분</th><th>총 입력 횟수</th><th>감지횟수</th><th>감지비율(%)</th><th>주요 감지<br/>악취강도<br/>(단위 : 도)</th><th>주요 냄새</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th colspan="2" class="statisticTableVerticalTh">합계</th>
                                <td>${result.userTotalCount}</td>
                                <td>${result.userRegisterCount}</td>
                                <td>${result.userRegisterPercentage}</td>
                                <td>${result.mainSmellValueName}</td>
                                <td>${result.mainSmellTypeName}</td>
                            </tr>
                            <c:forEach var="subItem" items="${result.list}" varStatus="status">
                                <c:set var="listItem" value="${result.list.get(status.index)}"/>
                                        <tr>
                                            <th class="userRegionMaster statisticTableVerticalTh">${listItem.userRegionMasterName}</th>
                                            <th class="statisticTableVerticalTh">${listItem.userRegionDetailName}</th>
                                            <td>${listItem.userTotalCount}</td>
                                            <td>${listItem.userRegisterCount}</td>
                                            <td>${listItem.userRegisterPercentage}</td>
                                            <td>${listItem.mainSmellValueName}</td>
                                            <td>${listItem.mainSmellTypeName}</td>
                                        </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
        </c:forEach>
        </div>
    </div>
</div>
</body>
</html>
