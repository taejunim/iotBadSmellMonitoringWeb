<%--
  Created by IntelliJ IDEA.
  User: guava
  Date: 2021/06/02
  Time: 2:45 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script type="text/javascript">
    //회원가입용 임시 아이디
    var tmpId = "";
    $(document).ready(function () {

        // 완료 버튼 클릭 이벤트
        $("#btnComplete").click(function(){
            join();
        });

        // 중복체크 버튼 클릭 이벤트
        $("#btnCheck").click(function(){
            idCheck();
        });
    });

    //회원가입
    function join() {

        //.joinForm에서 .formInput 찾기
        var inputList = $(".joinForm").find(".inputForm");
        var chk = true;

        //위에서 찾은 것들 중 빈값이 있는지 체크
        $(inputList).each(function (idx, obj) {
            if ($(obj).val().trim().length == 0) {
                $(obj).focus();

                var txt = $(obj).attr("placeholder");
                alert(txt);
                chk = false;
                return chk;
            }
        })

        //chk이 true일 경우
        if(chk) {
         var formData = $(".joinForm").serialize();
            if(tmpId == $("input[name='userId']").val()) {
                $.ajax({
                    url: "/join/userJoinInsert",
                    type: "POST",
                    data: formData,
                    dataType: "text",
                    success: function (data) {
                        if (data == "fail") return alert("이미 가입된 아이디입니다.");
                        alert("회원가입이 완료되었습니다.");
                        $(location).attr('href', '/login.do');
                    },
                    error: function (err) {
                        console.log(err)
                        alert("회원가입에 실패하였습니다.");
                    }
                });
            } else {
                return alert("아이디 중복체크를 수행하여 주십시오.");
            }
         }
    }

    function idCheck(){

        var userId = $("input[name='userId']").val();
        if(userId != "") {
            $.ajax({
                url: "/join/userFindIdSelect",
                type: "POST",
                data: {userId: userId},
                dataType: "text",
                success: function (data) {
                    if (data != "") return alert("이미 가입된 아이디입니다.");
                    alert("사용 가능한 아이디 입니다.");
                    tmpId = userId;
                },
                error: function (err) {
                    console.log(err)
                    alert("회원가입에 실패하였습니다.");
                }
            });
        }
    }
</script>

<body>
<div class="wd100rate h100rate scrollView">
    <div>
        <form:form class="joinForm" name="joinForm">
        <table class="blueForm wd450 mt200"; >
            <tr><th colspan="2">회원가입</th></tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 아이디</label></td>
                <td><div style="width: 100%; height: 100%">
                    <input type="text" name="userId" class="inputForm mt10 fl wd60rate" placeholder="아이디를 입력해 주십시오." maxlength="20">
                    <a id= "btnCheck" class="subButton mt10">중복체크</a>
                </div></td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 비밀번호</label></td>
                <td><input type="password" name="userPassword" class="inputForm fl" maxlength="20" placeholder="비밀번호를 입력해 주십시오."></td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 이름</label></td>
                <td><input type="text" name="userName" class="inputForm fl" placeholder="이름을 입력해 주십시오."></td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 나이</label></td>
                <td><input type="text" name="userAge" class="inputForm fl" placeholder="나이를 입력해 주십시오."></td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 지역</label></td>
                <td>
                    <select name="userRegion" class="selectForm fl" >
                        <c:forEach var="item" items="${CG_RGN}">
                            <option value="${item.codeId}">${item.codeIdName}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 성별</label></td>
                <td>
                    <select name="userSex" class="selectForm fl" >
                        <c:forEach var="item" items="${CG_SEX}">
                            <option value="${item.codeId}">${item.codeIdName}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 구분</label></td>
                <td>
                    <select name="userType" class="selectForm fl">
                        <c:forEach var="item" items="${CG_UST}">
                            <option value="${item.codeId}">${item.codeIdName}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2"><a class="button bgcDeepBlue wd60 font_bold" id="btnComplete">완료</a></td>
            </tr>
        </table>
        </form:form>
    </div>
</div>
 </body>
</html>
