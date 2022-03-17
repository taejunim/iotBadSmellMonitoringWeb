<%@ page language="java" contentType="application/vnd.ms-excel;" pageEncoding="UTF-8"%>
<meta http-equiv="content-type" content="application/vnd.ms-excel; charset=utf-8">
<%
    response.setHeader("Content-Disposition", "attachment; filename=LIST.xls");
    response.setHeader("Content-Description", "JSP Generated Data");
%>
<head>
    <h1>월 악취 모니터링 요원 출석일지</h1>
    <table border ="1">
        <tbody>
            <tr>
                <th rowspan="2">순번</th>
                <th rowspan="2">이름</th>
                <th rowspan="2">지역</th>
                <th colspan="${monthDate.size()}">출석 여부(o,x 표시)</th>
                <th rowspan="2">총 출석일수</th>
                <th rowspan="2">수당 지급 여부</th>
                <th rowspan="2">감독자 확인</th>
            </tr>
            <tr>
                <c:forEach var="monthList" items="${monthDate}" varStatus="status">
                    <td>${monthList.value}</td>
                </c:forEach>
            </tr>
            <c:forEach var="resultList" items="${resultList}" varStatus="status">
                <tr id="tr-hover">
                    <td style="text-align:center;">${status.index + 1}</td>
                    <td>${resultList.userName}</td>
                    <td>${resultList.userRegionName}</td>
                    <c:set var="userKey" value="${resultList.userId}"/>
                    <c:set var="sum" value="0"/>
                    <c:forEach var="memberMap" items="${attendMap[userKey]}" varStatus="status">
                        <c:choose>
                            <c:when test="${!empty memberMap.value}">
                                <c:forEach items="${memberMap.value}" var="cnt">
                                    <td>${cnt.cnt}</td>
                                    <c:if test="${cnt.cnt eq 'o'}">
                                        <c:set var= "sum" value="${sum + 1}"/>
                                    </c:if>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <td>x</td>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:choose>
                        <c:when test="${sum eq '' or empty sum}">
                            <td>-</td>
                        </c:when>
                        <c:otherwise>
                            <td><c:out value="${sum}"/></td>
                        </c:otherwise>
                    </c:choose>
                    <td> - </td>
                    <td> - </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>