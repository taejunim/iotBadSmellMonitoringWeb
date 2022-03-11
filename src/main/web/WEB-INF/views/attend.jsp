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
    $(document).ready(function () {
        setButton("member");             //선택된 화면의 메뉴색 변경 CALL
        setDropButton("attend");         //선택된 드롭다운 메뉴색 변경 CALL
    });

</script>
<body>
<div class="wd100rate h100rate scrollView">
    <jsp:include page="/menu"/>

</body>
</html>
