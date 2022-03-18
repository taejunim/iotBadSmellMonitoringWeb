<%--
  Created by IntelliJ IDEA.
  User: guava
  Date: 2022/03/11
  Time: 5:16 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script type="text/javascript">
    var userName = '${joinVO.userName}';       //검색조건_이름
    var srtDate = '${joinVO.srtDate}';       //검색조건_날짜_년도
    var endDate = '${joinVO.endDate}';       //검색조건_날짜_월
    var userRegionMaster = '${joinVO.userRegionMaster}'; //검색조건_지역
    var userRegionDetail = '${joinVO.userRegionDetail}'; //검색조건_상세지역
    $(document).ready(function () {
        setButton("member");             //선택된 화면의 메뉴색 변경 CALL
        setDropButton("attend");         //선택된 드롭다운 메뉴색 변경 CALL
        monthDate();

        /* 검색 화면 검색어 세팅 START*/
        //날짜 년
        if (srtDate != "" && srtDate != null)
            $("#srtDate").val(srtDate).prop("selected", true);
        //날짜 월
        if (endDate != "" && endDate != null)
            $("#endDate").val(endDate).prop("selected", true);
        //지역
        if (userRegionMaster != "" && userRegionMaster != null)
            $("#userRegionMaster").val(userRegionMaster).prop("selected", true);                        //VO 값 선택

        //상세지역
        if (userRegionDetail != "" && userRegionDetail != null)
            $("#userRegionDetail").val(userRegionDetail).prop("selected", true);                        //VO 값 선택

        /* 검색 화면 검색어 세팅 END*/

        //데이터 다운로드 클릭 이벤트
        $("#downloadButton").click(function(){
            //showLoader(true);
            document.frm.action = "<c:url value='/attendDataExcelDownload'/>";
            document.frm.submit();
        });

        // 지역 클릭 시 해당 지역상세 표출
        $("#userRegionMaster").on('change',function (){
            selectUserRegion(this.value);
        });

    });

    //페이지 이동 스크립트
    function fn_page(pageNo) {
        showLoader(true);
        //vo에 담긴 값이 입력된 값과 다를 경우 강제로 vo에 담긴 값을 form에 넣어주기
        if (userName !=  $("#userName")){
            frm.userName.value = userName;
        }
        if (srtDate !=  $("#srtDate")){
            frm.srtDate.value = srtDate;
        }
        if (endDate !=  $("#endDate")){
            frm.endDate.value = endDate;
        }
        if (userRegionMaster !=  $("#userRegionMaster")){
            frm.userRegionMaster.value = userRegionMaster;
        }
        if (userRegionDetail !=  $("#userRegionDetail")){
            frm.userRegionDetail.value = userRegionDetail;
        }
        frm.pageIndex.value = pageNo;
        document.frm.action = "<c:url value='/attend.do'/>";
        document.frm.submit();

    }

    //조회
    function fn_search() {
        showLoader(true);
        frm.pageIndex.value = 1;
        document.frm.action = "<c:url value='/attend.do'/>";
        document.frm.submit();
    }

    //초기화
    function fn_reset() {
        showLoader(true);
        $("#userName").val("");
        $("#srtDate").val("");
        $("#endDate").val("");
        $("#userRegionMaster").val("");
        $("#userRegionDetail").val("");

        frm.pageIndex.value = 1;
        document.frm.action = "<c:url value='/attend.do'/>";
        document.frm.submit();
    }

    //지역 선택시 해당지역상세 표출
    function selectUserRegion(referenceCodeId) {
        if (referenceCodeId) {
            $.ajax({
                url: "/attend/userRegionSelect",
                type: "POST",
                data: {codeGroup:"RGD", referenceCodeGroup:"REM", referenceCodeId:referenceCodeId },
                dataType: "JSON",
                success: function (data) {
                    $('#userRegionDetail option').remove();
                    $('#userRegionDetail').append("<option value=''>전체</option>");

                    $.each(data , function(i, val){
                        $('#userRegionDetail').append("<option value="+ val.codeId+">" + val.codeIdName + "</option>");
                    });
                },
                error: function (err) {
                    console.log(err)
                }
            });
        } else {
            $('#userRegionDetail option').remove();
            $('#userRegionDetail').append("<option value=''>전체</option>");
        }
    }

    //월, 일자 셋팅
    function monthDate() {
        var date = new Date();

        var year = date.getFullYear();
        $(".monthYearSelect").empty();
        for(var i=0; i<=10; i++){
            $(".yearSelect").append("<option value='"+ (year - i) +"'>"+(year - i) +"년"+"</option>");
        }
        for(var i=1; i<=12; i++){
            if(i < 10) $(".monthSelect").append("<option value='0"+ i +"'>0"+i +"월"+"</option>");
            else $(".monthSelect").append("<option value='"+ i +"'>"+i +"월"+"</option>");
        }
        var month = date.getMonth() + 1;
        if(month < 10) month = "0" + month;
        $(".monthSelect").val(month);
    }

</script>
<body>
<jsp:include page="/menu"/>
<div class="wd100rate h100rate scrollView">
    <form:form id="frm" name="frm" method="post">

    <table class="searchTable">
        <input type="hidden" id="pageIndex" name="pageIndex" value="${joinVO.pageIndex}">
        <tr>
            <th>이름</th>
            <td><input type="text" id="userName" name="userName" value="${joinVO.userName}" class="wd100"></td>
            <th>지역</th>
            <td>
                <select id="userRegionMaster" name="userRegionMaster" class="wd90">
                    <option value="">전체</option>
                    <c:forEach var="item" items="${CG_REM}">
                        <option value="${item.codeId}">${item.codeIdName}</option>
                    </c:forEach>
                </select>
            </td>
            <th>상세지역</th>
            <td>
                <select id="userRegionDetail" name="userRegionDetail" class="wd90">
                    <option value="">전체</option>
<%--                    <c:forEach var="item" items="${CG_RGN}">--%>
<%--                        <option value="${item.codeId}">${item.codeIdName}</option>--%>
<%--                    </c:forEach>--%>
                </select>
            </td>
            <th>월별</th>
            <td>
                <select class="wd100 monthYearSelect yearSelect" id="srtDate" name="srtDate"></select>
                <select class="wd100 monthYearSelect monthSelect" id="endDate" name="endDate"></select>
            </td>
            <td><a class="button resetBtn bgc_grayC mt10 fr" onclick="fn_reset();"><i class="bx bx-redo"></i>초기화</a>
                <a class="button bgcSkyBlue mt10 fr" onclick="fn_search();"><i class="bx bx-search"></i>조회</a>
                <a class="button bgcDeepBlue mt10 fr" id="downloadButton"><i class="bx bx-download"></i>엑셀</a></td>
        </tr>
    </table>
    <div class="wd100rate h100rate bgc_w scrollView">
        <div class="wd100rate h100rate fl brDeepBlue">
            <table class=" viewTable font_size13">
                <tr>
                    <th class="wd5rate" rowspan="2">순번</th>
                    <th rowspan="2">이름</th>
                    <th rowspan="2">지역</th>
                    <th colspan="${monthDate.size()}">출석 여부(o,x 표시)</th>
                    <th rowspan="2">총 출석일수</th>
                    <th rowspan="2">수당 지급 여부</th>
                    <th rowspan="2">감독자 확인</th>
                </tr>
                <tr>
                    <c:forEach var="monthList" items="${monthDate}" varStatus="status">
                        <td>${monthList.value}</td>
                    </c:forEach>
                </tr>
                <c:forEach var="resultList" items="${resultList}" varStatus="status">
                    <tr class="cursor_pointer" id="tr-hover">
                        <td>${paginationInfo.totalRecordCount - ((joinVO.pageIndex-1) * 10) - status.index}</td>
                        <td>${resultList.userName}</td>
                        <td>${resultList.userRegionName}</td>
                            <c:set var="userKey" value="${resultList.userId}"/>
                            <c:set var="sum" value="0"/>
                            <c:forEach var="memberMap" items="${attendMap[userKey]}" varStatus="status">
                                <c:choose>
                                    <c:when test="${!empty memberMap.value}">
                                        <c:forEach items="${memberMap.value}" var="cnt">
                                            <td>${cnt.cnt}</td>
                                            <c:if test="${cnt.cnt eq 'o'}">
                                                <c:set var= "sum" value="${sum + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <td>x</td>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${sum eq '' or empty sum}">
                                    <td>-</td>
                                </c:when>
                                <c:otherwise>
                                    <td><c:out value="${sum}"/></td>
                                </c:otherwise>
                            </c:choose>
                        <td> - </td>
                        <td> - </td>
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
    </div>
</div>
</form:form>
</body>
</html>
