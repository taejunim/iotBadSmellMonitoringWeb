<!--
  Created by IntelliJ IDEA.
  User: guava
  Date: 2021/05/27
  Time: 9:49 오전
  To change this template use File | Settings | File Templates.
-->
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script type="text/javascript">

  $(document).ready(function () {

    //회원가입 Click
    $("#join").click(function(){
      $(location).attr('href', '/join.do');
    });
    //로그인 Click
    $("#login").click(function(){
      login();
    });
    //비밀번호 입력창에서 엔터
    $("#password").keydown(function (key) {
      if (key.keyCode == 13) {
        login();
      }
    });
    //비밀번호 분실 Click
    $("#lostPassword").click(function(){
      alert("비밀번호 분실시에는 관리자에게 문의 바랍니다.");
    });
  });
  function login() {

    //.loginForm에서 .formInput 찾기
    var inputList = $(".loginForm").find(".formInput");
    var chk = true;
    //위에서 찾은 것들 중 빈값이 있는지 체크
    $(inputList).each(function (idx, obj) {

      if($(obj).val().trim().length == 0){
        $(obj).focus();

        var txt = $(obj).attr("placeholder");
        alert(txt +"를 입력해 주세요.");
        chk = false;
        return chk;
      }
    })

    if(chk) {
      var formData = $(".loginForm").serialize();

      $.ajax({
        url: "/login",
        type: "POST",
        data: formData,
        dataType: "text",
        success: function (data) {
          //입력한 정보가 잘못됬을때
          if (data == "wrongFail") return alert("아이디 또는 비밀번호가 잘못되었습니다. 입력하신 정보를 확인하여 주십시오.");
          //일반 사용자일때
          else if (data == "authFail") return alert("일반 사용자는 이용이 제한됩니다. 관리자 계정으로 시도하여 주십시오.");
          else $(location).attr('href', '/main.do');
        },
        error: function (err) {
          alert("로그인에 실패하셨습니다.");
        }
      });
    }
  }
</script>
  <body>
  <div class="wd100rate h100rate scrollView">
  <div>
  <form:form class="loginForm">
    <table class="blueForm wd500 mt220">
      <tr><th class="h70" style="line-height: 30px;"><a class="font_bold font_size20">악취 모니터링 시스템</a><br>로그인</th></tr>
      <tr><td class="h20"></td></tr>
      <tr><td><input type="text" name="userId" placeholder="아이디" class="formInput"></td></tr>
      <tr><td><input type="password" name="userPassword" placeholder="비밀번호" class="formInput" id="password"></td></tr>
      <tr><td><label id="lostPassword">비밀번호를 잃어버리셨습니까?</label></td></tr>
      <tr><td>
        <a id = "login" class="button bgcDeepBlue wd60 font_bold fr">로그인</a>
        <a id = "join" class="button bgcSkyBlue wd60 font_bold fr">회원가입</a>
      </td></tr>
    </table>
  </form:form>
  </div>
  </body>
</html>
