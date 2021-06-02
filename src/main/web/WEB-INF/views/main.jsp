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
    userId = "admin";

    setButton("main");
  });

</script>
  <body>
  <jsp:include page="/menu"/>
  </body>
</html>
