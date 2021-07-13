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

        $("#upload").click(function(){
            console.log("타는지");
            var formData = new FormData($("#fileForm")[0]);

            $.ajax({
                type : 'post',
                url : '/api/registerInsert',
                data : formData,
                processData : false,
                dataType : "json",
                contentType : false,
                async    : false,
                success : function(data) {
                    alert("파일 업로드 성공.");
                },
                error : function(error) {
                    alert("파일 업로드에 실패하였습니다.");

                }
            });

        });
    });



</script>
<body>
<jsp:include page="/menu"/>

<form id="fileForm" method="post" enctype="multipart/form-data">
    <span class="file" id="file">
        <input type="file" name="file1" >
        <label>파일찾기</label>
    </span>
    <input type="button" id="upload" value="전송"/>
</form>

</body>
</html>
