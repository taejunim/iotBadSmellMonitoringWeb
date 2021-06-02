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
    console.log("---");
  });

</script>
  <body>
  <jsp:include page="/menu"/>
  <div>
  <table class="blueForm wd500 mt200">
    <tr><th>로그인</th></tr>
    <tr><td class="h20"></td></tr>
    <tr><td><input type="text"placeholder="아이디"></td>></tr>
    <tr><td><input type="text" placeholder="비밀번호"></td></tr>
    <tr><td><label id="lostPassword">비밀번호를 잃어버리셨습니까?</label></td></tr>
    <tr><td>
      <a class="button bgcDeepBlue wd60 font_bold fr">로그인</a>
      <a class="button bgcSkyBlue wd60 font_bold fr">회원가입</a>
    </td></tr>
  </table>
  </div>
  </body>
</html>
