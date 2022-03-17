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

        // 취소 버튼 클릭 이벤트
        $("#btnCancel").click(function(){
            $(location).attr('href', '/login.do');
        });

        // 중복체크 버튼 클릭 이벤트
        $("#btnCheck").click(function(){
            idCheck();
        });

        // 지역 클릭 시 해당 지역상세 표출
        $("#selectRem").on('change',function (){
            selectUserRegion(this.value);
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
            //비밀번호 체크
            if (!fn_chkPw_pattern($("input[name='userPassword']").val())) {
                alert("비밀번호는 영문,숫자,특수문자를 최소 한가지씩 4~20자리로 입력해주세요.");

                return false;
            }

            //휴대폰 번호 체크
            if (!fn_chkNumber_pattern($("input[name='userPhone']").val())) {
                alert("휴대폰 번호를 바르게 입력해 주세요");

                return false;
            }

            if($("input[name='userPassword']").val() != $("input[name='userPasswordConfirm']").val()) {
                alert("비밀번호가 일치하지 않습니다.");
                return $("input[name='userPasswordConfirm']").val();
            }

            if(tmpId == $("input[name='userId']").val()) {
                if (confirm("회원가입을 진행하시겠습니까?")) {
                    var formData = $(".joinForm").serialize();
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
                }
            } else {
                return alert("아이디 중복체크를 수행하여 주십시오.");
            }
         }
    }

    function idCheck(){

        var userId = $("input[name='userId']").val();

        //아이디 체크
        if (!fn_chkId_pattern(userId)) {
            return;
        }

        //아이디 길이 확인
        // if(!fn_chkIdLength(userId)) {
        //     return;
        // }
        /*if(!fn_chkIdLength(userId)) {
            return;
        }*/

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

    //지역 선택시 해당지역상세 표출
    function selectUserRegion(referenceCodeId) {
        $.ajax({
            url: "/join/userRegionSelect",
            type: "POST",
            data: {codeGroup:"RGD", referenceCodeGroup:"REM", referenceCodeId:referenceCodeId },
            dataType: "JSON",
            success: function (data) {
                $('#userRegionDetail option').remove();
                $.each(data , function(i, val){
                    $('#userRegionDetail').append("<option value="+ val.codeId+">" + val.codeIdName + "</option>");
                });

            },
            error: function (err) {
                console.log(err)
            }
        });
    }
</script>

<body>
<div class="wd100rate h100rate scrollView">
    <div>
        <form:form class="joinForm" name="joinForm">
        <table class="blueForm wd780 mt130"; >
            <tr><th colspan="2">회원가입</th></tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 아이디</label></td>
                <td><div style="width: 100%; height: 100%">
                    <input type="text" id="userId" name="userId" class="inputForm mt10 fl wd66rate" placeholder="아이디는 영문 및 숫자 4~20자리로 입력해주세요." maxlength="20">
                    <a id= "btnCheck" class="subButton mt10">중복체크</a>
                </div></td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 비밀번호</label></td>
                <td><input type="password" name="userPassword" class="inputForm fl" maxlength="20" id="userPassword" placeholder="비밀번호는 영문,숫자,특수문자를 최소 한가지씩 4~20자리로 입력해주세요."></td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 비밀번호 확인</label></td>
                <td><input type="password" name="userPasswordConfirm" class="inputForm fl" maxlength="20" id="userPasswordConfirm" placeholder="비밀번호는 영문,숫자,특수문자를 최소 한가지씩 4~20자리로 입력해주세요."></td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 이름</label></td>
                <td><input type="text" name="userName" class="inputForm fl" placeholder="이름을 입력해 주십시오." maxlength="10"></td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 휴대폰 번호</label></td>
                <td><div style="width: 100%; height: 100%">
                    <input type="text" id="" name="userPhone" class="inputForm mt10 fl wd66rate" placeholder="휴대폰번호를 '-'없이 입력해 주십시오." maxlength="20">
                    <a id= "btnCheck_phone" class="subButton mt10">인증하기</a>
                </div></td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 나이</label></td>
                <td><input type="text" name="userAge" class="inputForm fl" placeholder="나이를 입력해 주십시오." maxlength="3"></td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 지역</label></td>
                <td>
                    <select id="selectRem" name="userRegionMaster" class="selectForm fl required" >
                        <option value="">지역을 선택하여 주세요</option>
                        <c:forEach var="item" items="${CG_REM}">
                            <option value="${item.codeId}">${item.codeIdName}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>

            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 지역상세</label></td>
                <td>
                    <select id="userRegionDetail" name="userRegionDetail" class="selectForm fl required" >
                        <option value="">상세지역을 선택하여 주세요</option>
<%--                        <c:forEach var="item" items="${CG_RGN}">--%>
<%--                            <option value="${item.codeId}">${item.codeIdName}</option>--%>
<%--                        </c:forEach>--%>
                    </select>
                </td>
            </tr>


            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 성별</label></td>
                <td>
                    <select name="userSex" class="selectForm fl required" >
                        <c:forEach var="item" items="${CG_SEX}">
                            <option value="${item.codeId}">${item.codeIdName}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="align_l pl20"><label class="tableLabel">* 구분</label></td>
                <td>
                    <select name="userType" class="selectForm fl required" >
                        <c:forEach var="item" items="${CG_UST}">
                            <c:choose>
                                <c:when test="${item.codeGroup eq 'UST' and item.codeId eq '002'}">
                                    <option value="${item.codeId}" selected>${item.codeIdName}</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${item.codeId}">${item.codeIdName}</option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <a class="button bgc_grayC wd60 font_bold" id="btnCancel">취소</a>
                    <a class="button bgcDeepBlue wd60 font_bold" id="btnComplete">완료</a>
                </td>

            </tr>
        </table>
        </form:form>
    </div>
</div>
 </body>
</html>
