<%@ page language="java" contentType="application/vnd.ms-excel;" pageEncoding="UTF-8"%>
<meta http-equiv="content-type" content="application/vnd.ms-excel; charset=utf-8">
<%
    response.setHeader("Content-Disposition", "attachment; filename=LIST.xls");
    response.setHeader("Content-Description", "JSP Generated Data");
%>
<head>
        <table border="1">
            <tbody>
                <tr>
                    <th>순번</th>
                    <th>기상 상태</th>
                    <th>접수 시간대</th>
                    <th>악취 강도</th>
                    <th>취기</th>
                    <th>등록자 아이디</th>
                    <th>등록자</th>
                    <th>등록일시</th>
                </tr>
                <c:forEach var="resultList" items="${resultList}" varStatus="status">
                <tr>
                    <td style="text-align:center;">${status.index + 1}</td>
                    <td>${resultList.weatherStateName}</td>
                    <td>${resultList.smellRegisterTimeName}</td>
                    <td>${resultList.smellValueName}</td>
                    <td>${resultList.smellTypeName}</td>
                    <td>${resultList.regId}</td>
                    <td>${resultList.userName}</td>
                    <td style='mso-number-format: "yyyy-mm-dd hh:mm:ss";'>${resultList.regDt}</td>
                </tr>
                </c:forEach>
            </tbody>
        </table>