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

    var userName          = '${joinVO.userName}';               //검색조건_아이디/이름
    var userRegionMaster  = '${joinVO.userRegionMaster}';       //검색조건_지역
    var userRegionDetail  = '${joinVO.userRegionDetail}';       //검색조건_지역_상세
    var searchYear        = '${joinVO.searchYear}';             //검색조건_연
    var searchMonth       = '${joinVO.searchMonth}';            //검색조건_월

    $(document).ready(function () {

        setButton("member");             //선택된 화면의 메뉴색 변경 CALL
        setDropButton("attend");         //선택된 드롭다운 메뉴색 변경 CALL
        monthDate();                     //월, 일자 셋팅 CALL

        /* 검색 화면 검색어 세팅 START*/
        //지역
        if (userRegionMaster != "" && userRegionMaster != null) {
            $("#userRegionMaster").val(userRegionMaster).prop("selected", true);                        //VO 값 선택
            selectUserRegion(userRegionMaster);
        }

        if (searchYear != "" && searchYear != null) {
            $("#searchYear").val(searchYear).prop("selected", true);                        //VO 값 선택
        }

        if (searchMonth != "" && searchMonth != null) {
            $("#searchMonth").val(searchMonth).prop("selected", true);                        //VO 값 선택
        }

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
        if (searchYear !=  $("#searchYear")){
            frm.searchYear.value = searchYear;
        }
        if (searchMonth !=  $("#searchMonth")){
            frm.searchMonth.value = searchMonth;
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
        $("#searchYear").val("");
        $("#searchMonth").val("");
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

                },
                error: function (err) {
                    console.log(err)
                }
            }).done(function (data) {

                $('#userRegionDetail option').remove();
                $('#userRegionDetail').append("<option value=''>전체</option>");

                $.each(data , function(i, val){
                    $('#userRegionDetail').append("<option value="+ val.codeId+">" + val.codeIdName + "</option>");
                });

                //상세지역
                if (userRegionDetail != "" && userRegionDetail != null)
                    $("#userRegionDetail").val(userRegionDetail).prop("selected", true);                                //VO 값 선택
            })
            ;
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
        <input type="hidden" id="pageIndex" name="pageIndex" value="${joinVO.pageIndex}">
    <table class="searchTable">

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
                </select>
            </td>
            <th>월별</th>
            <td>
                <select class="wd100 monthYearSelect yearSelect"  id="searchYear"    name="searchYear"></select>
                <select class="wd100 monthYearSelect monthSelect" id="searchMonth"   name="searchMonth"></select>
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
                    <th colspan="${dateCount}">${joinVO.searchYear}년 ${joinVO.searchMonth}월 출석 여부(o,x 표시)</th>
                    <th rowspan="2">총 출석일수</th>
                    <th rowspan="2">수당 지급 여부</th>
                    <th rowspan="2">감독자 확인</th>
                </tr>
                <tr>
                    <c:forEach var="dateList" items="${dateList}" varStatus="status">
                        <td>${dateList.day}</td>
                    </c:forEach>
                </tr>
                <c:forEach var="resultList" items="${resultList}" varStatus="status">
                <tr>
                    <td>${paginationInfo.totalRecordCount - ((joinVO.pageIndex-1) * 10) - status.index}</td>
                    <td>
                        ${resultList.userName}
                    </td>
                    <td>
                        ${resultList.userRegionMasterName}&nbsp;${resultList.userRegionDetailName}
                    </td>
                    <c:forEach var="i" begin="0" end="${dateCount-1}">
                        <c:set var="b" value="day${i}" />
                        <td>
                            ${resultList[b]}
                        </td>
                    </c:forEach>
                    <td>
                        ${resultList.userRegCount}
                    </td>
                    <td>
                        ${resultList.userDayCheck}
                    </td>
                    <td>

                    </td>
                </tr>
                </c:forEach>
                <c:if test="${empty resultList}">
                    <tr>
                        <td align="center" colspan="${dateCount+6}" rowspan="2">- 해당 데이터가 존재하지 않습니다. -</td>
                    </tr>
                </c:if>
            </table>
            <div id="pagination" class="pagingBox align_c">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page"/>
            </div>
        </div>
    </div>
    </form:form>
</div>
</body>
</html>
