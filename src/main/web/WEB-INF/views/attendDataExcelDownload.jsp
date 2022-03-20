<%@ page import="static iotBadSmellMonitoring.member.web.AttendController.exceclYear" %>
<%@ page import="static iotBadSmellMonitoring.member.web.AttendController.exceclMonth" %>
<%@ page language="java" contentType="application/vnd.ms-excel;" pageEncoding="UTF-8"%>

<meta http-equiv="content-type" content="application/vnd.ms-excel; charset=utf-8">
<%
    String filename = exceclYear + new String("년".getBytes(), "8859_1") + exceclMonth + new String("월".getBytes(), "8859_1") + new String(" 모니터링 요원 출석일지".getBytes(), "8859_1");
    response.setHeader("Content-Disposition", "attachment; filename="+ filename + ".xls");
    response.setHeader("Content-Description", "JSP Generated Data");
%>
<head>
    <h1>${joinVO.searchYear}년 ${joinVO.searchMonth}월 악취 모니터링 요원 출석일지</h1>
    <table border="1">
        <tr>
            <th rowspan="2">이름</th>
            <th rowspan="2">지역</th>
            <th rowspan="2">지역 상세</th>
            <th colspan="${dateCount}">${joinVO.searchYear}년 ${joinVO.searchMonth}월 출석 여부(o,x 표시)</th>
            <th rowspan="2">총 출석일수</th>
            <th rowspan="2">수당 지급 여부</th>
            <th rowspan="2">감독자 확인</th>
        </tr>
        <tr>
            <c:forEach var="dateList" items="${dateList}" varStatus="status">
                <td>${dateList.day}</td>
            </c:forEach>
        </tr>
        <c:forEach var="resultList" items="${resultList}" varStatus="status">
            <tr>
                <td>
                        ${resultList.userName}
                </td>
                <td>
                        ${resultList.userRegionMasterName}
                </td>
                <td>
                        ${resultList.userRegionDetailName}
                </td>
                <c:forEach var="i" begin="0" end="${dateCount-1}">
                    <c:set var="b" value="day${i}" />
                    <td>
                            ${resultList[b]}
                    </td>
                </c:forEach>
                <td style="mso-number-format:\@">
                    <c:out value="${resultList.userRegCount}"/>
                </td>
                <td>
                        ${resultList.userDayCheck}
                </td>
                <td>

                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty resultList}">
            <tr>
                <td align="center" colspan="${dateCount+6}" rowspan="2">- 해당 데이터가 존재하지 않습니다. -</td>
            </tr>
        </c:if>
    </table>
