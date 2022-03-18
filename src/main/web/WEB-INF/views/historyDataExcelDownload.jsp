<%@ page language="java" contentType="application/vnd.ms-excel;" pageEncoding="UTF-8"%>
<meta http-equiv="content-type" content="application/vnd.ms-excel; charset=utf-8">
<%
    String filename = new String("주민악취접수이력".getBytes(), "8859_1");
    response.setHeader("Content-Disposition", "attachment; filename="+ filename + ".xls");
    response.setHeader("Content-Description", "JSP Generated Data");
%>
<head>
    <h1>개별접수이력조회</h1>
        <table border="1">
            <tbody>
                <tr>
                    <th>순번</th>
                    <th>기상 상태</th>
                    <th>접수 시간대</th>
                    <th>악취 강도</th>
                    <th>취기</th>
                    <th>습도(%)</th>
                    <th>온도(℃)</th>
                    <th>풍향</th>
                    <th>풍속(m/s)</th>
                    <th>미세먼지 측정소명/장치ID</th>
                    <th>PM10 미세먼지 평균 값 (㎍/㎥)</th>
                    <th>공기질 수집일시</th>
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
                    <td>${resultList.humidityValue}</td>
                    <td>${resultList.temperatureValue}</td>
                    <td>${resultList.windDirectionValueName}</td>
                    <td>${resultList.windSpeedValue}</td>
                    <td>${resultList.airSensorName}</td>
                    <td>${resultList.pm10Avg}</td>
                    <td style='mso-number-format: "yyyy-mm-dd hh:mm:ss";'>${resultList.airSensingDate}</td>
                    <td>${resultList.regId}</td>
                    <td>${resultList.userName}</td>
                    <td style='mso-number-format: "yyyy-mm-dd hh:mm:ss";'>${resultList.regDt}</td>
                </tr>
                </c:forEach>
            </tbody>
        </table>