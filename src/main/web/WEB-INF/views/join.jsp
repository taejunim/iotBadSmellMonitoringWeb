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

    $(document).ready(function () {
        console.log("---");
    });

</script>
    <body>
    <jsp:include page="/menu"/>
    <div>
        <table class="blueForm wd450 mt200"; >
            <tr><th colspan="2">회원가입</th></tr>
            <tr><td class="align_l pl20"><label class="tableLabel">* 아이디</label></td><td><input type="text" placeholder="아이디를 입력해 주십시오."></tr>
            <tr><td class="align_l pl20"><label class="tableLabel">* 비밀번호</label></td><td><input type="text" placeholder="비밀번호를 입력해 주십시오."></td></tr>
            <tr><td class="align_l pl20"><label class="tableLabel">* 이름</label></td><td><input type="text" placeholder="이름을 입력해 주십시오."></td></tr>
            <tr><td class="align_l pl20"><label class="tableLabel">* 나이</label></td><td><input type="text" placeholder="나이를 입력해 주십시오."></td></tr>
            <tr><td class="align_l pl20"><label class="tableLabel">* 성별</label></td><td><select><option>남성</option><option>여성</option></select></td></tr>
            <tr><td class="align_l pl20"><label class="tableLabel">* 구분</label></td><td> <select><option>일반</option><option>관리자</option></select></td></tr>
            <tr><td colspan="2"><a class="button bgcDeepBlue wd60"><strong>완료</strong></a></td></tr>
        </table>
    </div>
    </body>
</html>
