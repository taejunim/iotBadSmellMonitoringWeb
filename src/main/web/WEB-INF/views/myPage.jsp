<%--
  Created by IntelliJ IDEA.
  User: guava
  Date: 2021/06/02
  Time: 3:53 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script type="text/javascript">

    $(document).ready(function () {

        setButton("myPage");                        //선택된 화면의 메뉴색 변경 CALL

        /*세션값 불러오기 START*/
        $("#showId").val('<%=(String)session.getAttribute("userId")%>');                                    //아이디
        $("#showPassword").val("");                                                                         //사용자_비밀번호
        $("#showName").val('<%=(String)session.getAttribute("userName")%>');                                //이름
        $("#showAge").val('<%=(String)session.getAttribute("userAge")%>');                                  //나이

        $("#userRegion").empty();                                                                           //지역 구분 이름
        $("#userRegion").append("<option>"+'<%=(String)session.getAttribute("userRegionName")%>'+"</option>");

        $("#userSex").empty();                                                                              //성별 이름
        $("#userSex").append("<option>"+'<%=(String)session.getAttribute("userSexName")%>'+"</option>");

        $("#userType").empty();                                                                             //사용자 구분 이름
        $("#userType").append("<option>"+'<%=(String)session.getAttribute("userTypeName")%>'+"</option>");
        /*세션값 불러오기 END*/

        //비밀번호변경 버튼 클릭 이벤트
        $("#updateBtn").click(function () {

            var getPw = $("#showPassword").val();
            var chkPw = $("#showPasswordConfirm").val();

            //변경할 비밀번호 값 입력 안했을 경우
            if (getPw === undefined || getPw === "") {
                alert("변경할 비밀번호를 입력해 주십시오.");
                return false;
            //비밀번호 확인 값 입력 안했을 경우
            }else if (chkPw === undefined || chkPw === ""){
                alert("비밀번호 확인을 입력해 주십시오.");
                return false;
            }

            //비밀번호 확인 값 일치하지 않을 경우
            if(getPw != $("#showPasswordConfirm").val().trim()) {
                alert("비밀번호가 일치하지 않습니다.");
                $("#showPasswordConfirm").focus();
                return false;
            }

            var con_test = confirm("비밀번호를 변경하시겠습니까?");

            //비밀번호 변경 confirm true일 경우
            if(con_test == true) {
                $.ajax({
                    url: "/myPagePasswordUpdate/",
                    type: "POST",
                    data: {userPassword: $("#showPassword").val(), userId: $("#showId").val()},
                    dataType: "text",
                    success: function (data) {
                        alert("비밀번호를 변경하였습니다.");
                        // memberFormClear();
                    },
                    error: function (err) {
                        console.log(err);
                        alert("비밀번호 변경을 실패하였습니다.");
                    }
                });
            }
        })

        //탈퇴 버튼 클릭 이벤트
        $("#deleteBtn").click(function () {

            var getUserId = $("#showId").val();

            var con_test = confirm(getUserId+"을(를) 탈퇴시키겠습니까?");

            //탈퇴버튼 confirm true일 경우
            if(con_test == true){
                $.ajax({
                    url: "/myPageDelete/",
                    type: "POST",
                    data: {userId: $("#showId").val()},
                    dataType: "text",
                    success: function (data) {
                        alert("회원 탈퇴를 성공하였습니다.");
                        $(location).attr('href', '/login.do');
                    },
                    error: function (err) {
                        console.log(err);
                        alert("회원 탈퇴를 실패하였습니다.");
                    }
                });
            }
        })
    });
</script>
<body>
<div class="wd100rate h100rate scrollView">
<jsp:include page="/menu"/>
<div>
    <form:form method="post">
        <table class="whiteForm wd30rate h70rate mt4rate mt130">
        <tr><th colspan="2"></th></tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel">아이디</label></td>
            <td><input type="text" id="showId" name="userId" placeholder="아이디"disabled></td>
        </tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel" >비밀번호</label></td>
            <td><input type="password" id="showPassword" name="userPassword" placeholder="비밀번호" maxlength="20"></td>
        </tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel" >비밀번호 확인</label></td>
            <td><input type="password" id="showPasswordConfirm" placeholder="비밀번호" maxlength="20"></td>
        </tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel" >이름</label></td>
            <td><input type="text" id="showName" name="userName" placeholder="이름"disabled></td>
        </tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel">나이</label></td>
            <td><input type="text" id="showAge" name="userAge" placeholder="나이"disabled></td>
        </tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel">지역</label></td>
            <td><select class="bgc_grayC" disabled id="userRegion"></select></td>
        </tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel">성별</label></td>
            <td><select class="bgc_grayC" disabled id="userSex"></select></td>
        </tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel">구분</label></td>
            <td><select class="bgc_grayC" disabled id="userType"></select></td>
        </tr>
        <tr>
            <td colspan="2">
                <a class="button bgcDeepBlue wd80" id="updateBtn"><strong>비밀번호 변경</strong></a>
                <a class="button bgcDeepRed wd80" id="deleteBtn"><strong>회원 탈퇴</strong></a>
            </td>
        </tr>
    </table>
    </form:form>
</div>
</body>
</html>