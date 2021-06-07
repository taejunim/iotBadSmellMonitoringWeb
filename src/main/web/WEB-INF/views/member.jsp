<!--
Created by IntelliJ IDEA.
User: guava
Date: 2021/06/02
Time: 9:49 오전
To change this template use File | Settings | File Templates.
-->
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script type="text/javascript">

    $(document).ready(function () {
        setButton("member");

        /* 검색 화면 검색어 세팅 START*/
        var userSex = '${joinVO.userSex}';

        if (userSex != "" && userSex != null)
            $("#searchUserSex").val(userSex).prop("selected", true);                              //VO 값 선택

        var userType = '${joinVO.userType}';

        if (userType != "" && userType != null)
            $("#searchUserType").val(userType).prop("selected", true);                              //VO 값 선택
        /* 검색 화면 검색어 세팅 END*/


        // 테이블 row 클릭 이벤트
        $(".itemRow").click(function () {

            var getItems = $(this).find("td");

            $("#userPassword").val("");
            $("#userId").val(getItems.eq(2).text());
            $("#userName").val(getItems.eq(4).text());
            $("#userAge").val(getItems.eq(3).text());

            $("#userSex").empty();
            $("#userSex").append("<option>"+getItems.eq(5).text()+"</option>");

            $("#userType").empty();
            $("#userType").append("<option>"+getItems.eq(1).text()+"</option>");

        })

        //저장 버튼 클릭 이벤트
        $("#memberSaveBtn").click(function () {

            var getPw = $("#userPassword").val().trim();

            // 회원을 선택 했는지 체크
            if($("#userId").val() === undefined || $("#userId").val().trim() === ""){
                alert("변경할 회원을 선택해 주세요.");
                return false;
            }

            if (getPw === undefined || getPw === "") {
                alert("변경할 비밀번호를 입력해 주세요.");
                return false;
            }

            $.ajax({
                url: "/memberPasswordUpdate/",
                type: "POST",
                data: {userPassword: $("#userPassword").val(), userId: $("#userId").val()},
                dataType: "text",
                success: function (data) {
                    alert("비밀번호를 변경하였습니다.");
                    memberFormClear();
                },
                error: function (err) {
                    console.log(err);
                    alert("비밀번호 변경을 실패하였습니다.");
                }
            });
        })

        //탈퇴 버튼 클릭 이벤트
        $("#memberDeleteBtn").click(function () {

            var getUserId = $("#userId").val().trim();
            // 회원을 선택 했는지 체크
            if(getUserId === undefined || getUserId === ""){
                alert("탈퇴할 회원을 선택해 주세요.");
                return false;
            }

            //로그인한 아이디는 탈퇴 X
            if(userId === getUserId){
                alert("로그인한 상태에서는 탈퇴할 수 없습니다.");
                return false;
            }

            var con_test = confirm(getUserId+"을 탈퇴시키겠습니까?");
            if(con_test == true){
                $.ajax({
                    url: "/memberDelete/",
                    type: "POST",
                    data: {userId: $("#userId").val()},
                    dataType: "text",
                    success: function (data) {
                        alert("회원 탈퇴를 성공하였습니다.");
                        fn_page($("#pageIndex").val());
                    },
                    error: function (err) {
                        console.log(err);
                        alert("회원 탈퇴를 실패하였습니다.");
                    }
                });
            }
        })

    });

    //회원정보 초기화
    function memberFormClear() {

        $("#userId").val("");
        $("#userPassword").val("");
        $("#userName").val("");
        $("#userAge").val("");

        $("#userSex").empty();
        $("#userType").empty();
    }

    //페이지 이동 스크립트
    function fn_page(pageNo) {

        frm.pageIndex.value = pageNo;
        document.frm.action = "<c:url value='/member.do'/>";
        document.frm.submit();
    }

    //조회
    function fn_seach() {

        frm.pageIndex.value = 1;
        document.frm.action = "<c:url value='/member.do'/>";
        document.frm.submit();
    }

</script>
<body>
<jsp:include page="/menu"/>
<table class="searchTable">

    <form:form id="frm" name="frm" method="post">
    <input type="hidden" id="pageIndex" name="pageIndex" value="${joinVO.pageIndex}">
    <tr>
        <th>아이디/이름</th>
        <td><input type="text" name="userId" value="${joinVO.userId}"></td>
        <th>나이</th>
        <td><input type="text" name="userAge" value="${joinVO.userAge}"></td>
        <th>성별</th>
        <td>
            <select id="searchUserSex" name="userSex">
                <option value="">전체</option>
                <c:forEach var="item" items="${CG_SEX}">
                    <option value="${item.codeId}">${item.codeIdName}</option>
                </c:forEach>
            </select>
        </td>
        <th>구분</th>
        <td>
            <select id="searchUserType" name="userType">
                <option value="">전체</option>
                <c:forEach var="item" items="${CG_UST}">
                    <option value="${item.codeId}">${item.codeIdName}</option>
                </c:forEach>
            </select>
        </td>
        <td><a class="button bgcSkyBlue mt10 fr" onclick="fn_seach();"><i class="bx bx-search"></i>조회</a></td>
    </tr>
</table>

<div class="wd100rate h100rate bgc_w">

    <div class="wd70rate h100rate fl brDeepBlue">
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
            <c:forEach var="resultList" items="${resultList}" varStatus="status">
                <tr class="cursor_pointer itemRow">
                    <td>${paginationInfo.totalRecordCount - ((joinVO.pageIndex-1) * 10) - status.index}</td>
                    <td>${resultList.userTypeName}</td>
                    <td>${resultList.userId}</td>
                    <td>${resultList.userName}</td>
                    <td>${resultList.userAge}</td>
                    <td>${resultList.userSexName}</td>
                    <td><fmt:formatDate value="${resultList.regDt}" pattern="yyyy-MM-dd hh:mm:ss"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty resultList}">
                <tr>
                    <td align="center" colspan="19">- 해당 데이터가 존재하지 않습니다. -</td>
                </tr>
            </c:if>
        </table>

        <hr id="pageline" class="wd95rate">
        <div id="pagination" class="pagingBox align_c">
            <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page"/>
        </div>

    </div>
    </form:form>
    <div class="h100rate fr wd28rate">
        <h2 class="mt50"><strong>회원정보</strong></h2>
        <form:form id="memberInfo" method="post">
            <table class="listTable wd95rate">
                <tr class="h57">
                    <td class="align_l wd130"><label>아이디</label></td>
                    <td><input type="text" readonly class="wd210" name="userId" id="userId" disabled></td>
                </tr>
                <tr class="h57">
                    <td class="align_l"><label>비밀번호</label></td>
                    <td><input type="password" class="wd180" name="userPassword" id="userPassword" maxlength="16"></td>
                </tr>
                <tr class="h57">
                    <td class="align_l"><label>이름</label></td>
                    <td><input type="text" readonly class="wd210" id="userName" disabled></td>
                </tr>
                <tr class="h57">
                    <td class="align_l"><label>나이</label></td>
                    <td><input type="text" readonly class="wd210" id="userAge" disabled></td>
                </tr>
                <tr class="h57">
                    <td class="align_l"><label>성별</label></td>
                    <td>
                        <select class="wd230 bgc_grayC" disabled id="userSex">
                        </select>
                    </td>
                </tr>
                <tr class="h57">
                    <td class="align_l"><label>구분</label></td>
                    <td>
                        <select class="wd230 bgc_grayC" disabled id="userType">
                        </select>
                    </td>
                </tr>
                <tr class="h80">
                    <td colspan="2" class="align_c">
                        <a class="button bgcDeepBlue" id="memberSaveBtn"><i class="bx bxs-save"></i><strong>저장</strong></a>
                        <a class="button bgcDeepRed" id="memberDeleteBtn"><i class="bx bx-minus-circle"></i>탈퇴</a>
                    </td>
                </tr>
            </table>
        </form:form>
    </div>

</div>
</body>
</html>
