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

        $("#showId").val(nullCheck('<%=(String)session.getAttribute("userId")%>'));                                     //아이디
        $("#showName").val('<%=(String)session.getAttribute("userName")%>');                                            //이름
        $("#userSex").val('<%=(String) session.getAttribute("userSexName")%>');                                         //성별
        $("#userType").val('<%=(String)session.getAttribute("userTypeName")%>');                                        //구분
        /*세션값 불러오기 END*/

        //비밀번호변경 버튼 클릭 이벤트
        $("#updateBtn").click(function () {

            var getPw = $("#userPassword").val().trim();

            //비밀번호 정규식
            if (!fn_chkPw_pattern(getPw)) {
                alert("비밀번호는 영문,숫자,특수문자를 최소 한가지씩 4~20자리로 입력해주세요.");
                $("#userPassword").focus();
                return false;
            }

            //비밀번호 일치 확인
            if (getPw != $("#userPasswordConfirm").val().trim()) {
                alert("비밀번호가 일치하지 않습니다.");
                $("#userPasswordConfirm").focus();
                return false;
            }

            var con_test = confirm("비밀번호를 변경하시겠습니까?");

            //비밀번호 변경 confirm true일 경우
            if(con_test == true) {
                $.ajax({
                    url: "/myPagePasswordUpdate/",
                    type: "POST",
                    data: {userPassword: $("#userPassword").val(), userId: $("#showId").val()},
                    dataType: "text",
                    success: function (data) {
                        alert("비밀번호를 변경하였습니다.");
                        $("#userPassword").val("");
                        $("#userPasswordConfirm").val("");
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

    //값 뿌리기 전 null을 체크
    function nullCheck(value){
        if(value == "null" || value == "") return "-";
        else return value;
    }

    //비밀번호 글자수 제한
    function length_check() {
        var title = $("#userPassword").val();

        if( title.length > 20 ) {
            alert("비밀번호는 20자를 초과할 수 없습니다.");
            $("#userPassword").val(title.substring(0, 20));
        }
    }
</script>
<body>
<div class="wd100rate scrollView">
<jsp:include page="/menu"/>
<div>
    <form:form method="post">
        <table class="whiteForm wd45rate mt4rate mt100">
        <tr><th colspan="2"></th></tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel">아이디</label></td>
            <td><input type="text" id="showId" name="userId" placeholder="아이디"disabled></td>
        </tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel" >비밀번호</label></td>
            <td><input type="password" id="userPassword" name="userPassword" onkeyup="length_check();" placeholder="영문,숫자,특수문자를 최소 한가지씩 4~20자리로 입력해주세요."></td>
        </tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel" >비밀번호 확인</label></td>
            <td><input type="password" id="userPasswordConfirm" onkeyup="length_check();" placeholder="영문,숫자,특수문자를 최소 한가지씩 4~20자리로 입력해주세요." ></td>
        </tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel" >이름</label></td>
            <td><input type="text" id="showName" name="userName" placeholder="이름"disabled></td>
        </tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel">성별</label></td>
            <td><input type="text" id="userSex" name="userSex" disabled></td>
        </tr>
        <tr>
            <td class="align_l pl20"><label class="tableLabel">구분</label></td>
            <td><input type="text" id="userType" name="userType" disabled></td>
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