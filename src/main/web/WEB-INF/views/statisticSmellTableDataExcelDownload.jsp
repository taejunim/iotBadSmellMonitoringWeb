<%@ page language="java" contentType="application/vnd.ms-excel;" pageEncoding="UTF-8"%>
<meta http-equiv="content-type" content="application/vnd.ms-excel; charset=utf-8">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
    <style>
        .statisticTable{
            text-align: center;
            width: 95%;
            font-size: 11px;
        }
        table > tbody > tr > td {
            border : 1px solid black;
        }
        .statisticTableTh {
            background: rgb(192,192,192);
            border : 1pt solid black;
        }
        .statisticTable > tbody > tr > td{
            border: 0.5pt solid black;
            height: 40px;
            text-align:center;
        }
        .resultLabel {
            border : 0.5pt solid black;
            background: #fff2cc;
            text-align: center;
        }
        .borderNone {
            border : none ! important;
            background: rgb(255,255,255);
        }
    </style>
<%
    String filename = new String("주민_취기_모니터링_결과_통계".getBytes(), "8859_1");
    response.setHeader("Content-Disposition", "attachment; filename="+ filename + ".xls");
    response.setHeader("Content-Description", "JSP Generated Data");
%>
    <c:choose>
        <c:when test="${userRegionDetail eq '' || userRegionDetail eq null}">
                <table>
                    <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                    <tr>
                        <td class="borderNone"></td>
                        <td class="resultLabel" colspan="11">
                            주민 악취모니터링 주요 취기 결과(${statisticTableVO.searchStart} ~ ${statisticTableVO.searchEnd})
                        </td>
                    </tr>
                    <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                </table>
                <table class="statisticTable">
                    <thead>
                        <tr>
                            <td class="borderNone" style="border-top: none !important;"></td>
                            <th colspan="11">&lt;주민 악취모니터링 주요 취기 결과&gt;</th>
                        </tr>
                        <tr class="statisticTableTh">
                            <td class="borderNone"></td>
                            <th colspan="3" class="">구분</th>
                            <th class="">돈사취</th>
                            <th class="">계사취</th>
                            <th class="">우사취</th>
                            <th class="">액비</th>
                            <th class="">퇴비</th>
                            <th class="">음식물</th>
                            <th class="">자숙</th>
                            <th class="">기타냄새</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${resultList}" begin="1" end="1">
                            <tr>
                                <td class="borderNone"></td>
                                <td colspan="2" style="border: 0.5pt solid black;">계</td>
                                <td style="border: 0.5pt solid black;">${resultList.totalCount}</td>
                                <td style="border: 0.5pt solid black;">${resultList.pigSmell}</td>
                                <td style="border: 0.5pt solid black;">${resultList.chikenSmell}</td>
                                <td style="border: 0.5pt solid black;">${resultList.cowSmell}</td>
                                <td style="border: 0.5pt solid black;">${resultList.waterCompostSmell}</td>
                                <td style="border: 0.5pt solid black;">${resultList.compostSmell}</td>
                                <td style="border: 0.5pt solid black;">${resultList.foodSmell}</td>
                                <td style="border: 0.5pt solid black;">${resultList.steamSmell}</td>
                                <td style="border: 0.5pt solid black;">${resultList.otherSmell}</td>
                            </tr>
                        </c:forEach>
                        <c:set value="${resultListDetail}" var="resultListDetail"/>
                            <c:forEach var="subItem" items="${resultListDetail.list}" varStatus="status">
                                <c:set var="listItem" value="${resultListDetail.list.get(status.index)}"/>
                                <tr>
                                    <c:choose>
                                        <c:when test="${status.index eq 0}">
                                            <td rowspan="${regionCountMap.get(listItem.userRegionMaster)}" class="borderNone"></td>
                                            <td rowspan="${regionCountMap.get(listItem.userRegionMaster)}" style="border: 0.5pt solid black;">${listItem.userRegionMasterName}</td>
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${status.last}">
                                                    <td rowspan="${regionCountMap.get(listItem.userRegionMaster)}" class="borderNone" style="border-bottom: none !important;"></td>
                                                    <td rowspan="${regionCountMap.get(listItem.userRegionMaster)}" style="border: 0.5pt solid black;">${listItem.userRegionMasterName}</td>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:if test="${listItem.userRegionMaster ne resultListDetail.list.get(status.index - 1).userRegionMaster}">
                                                        <td rowspan="${regionCountMap.get(listItem.userRegionMaster)}" class="borderNone"></td>
                                                        <td rowspan="${regionCountMap.get(listItem.userRegionMaster)}" style="border: 0.5pt solid black;">${listItem.userRegionMasterName}</td>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                    <td style="border: 0.5pt solid black;">${listItem.userRegionDetailName}</td>
                                    <td style="border: 0.5pt solid black;">${listItem.totalCount}</td>
                                    <td style="border: 0.5pt solid black;">${listItem.pigSmell}</td>
                                    <td style="border: 0.5pt solid black;">${listItem.chikenSmell}</td>
                                    <td style="border: 0.5pt solid black;">${listItem.cowSmell}</td>
                                    <td style="border: 0.5pt solid black;">${listItem.waterCompostSmell}</td>
                                    <td style="border: 0.5pt solid black;">${listItem.compostSmell}</td>
                                    <td style="border: 0.5pt solid black;">${listItem.foodSmell}</td>
                                    <td style="border: 0.5pt solid black;">${listItem.steamSmell}</td>
                                    <td style="border: 0.5pt solid black;">${listItem.otherSmell}</td>
                                </tr>
                            </c:forEach>
                    </tbody>
                </table>
        </c:when>
        <c:otherwise>
            <table>
                <tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                <tr>
                    <td></td>
                    <td class="resultLabel" colspan="5">
                            ${userRegionDetailName}-주민 악취모니터링 결과(${statisticTableVO.searchStart} ~ ${statisticTableVO.searchEnd})
                    </td>
                </tr>
                <tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>
            </table>
            <table class="statisticTable">
                <tbody>
                    <tr class="statisticTableTh">
                        <td class="borderNone"></td>
                        <th rowspan="2">구분</th>
                        <th rowspan="2">총<br>입력횟수</th>
                        <th rowspan="2">악취<br>감지횟수</th>
                        <th rowspan="2">악취<br>감지비율</th>
                        <th colspan="5">악취강도</th>
                    </tr>
                    <tr class="statisticTableTh">
                        <td class="borderNone"></td>
                        <th>1도</th>
                        <th>2도</th>
                        <th>3도</th>
                        <th>4도</th>
                        <th>5도</th>
                    </tr>
                    <c:forEach items="${resultList}" var="resultByRegion" varStatus="status">
                        <c:if test="${resultByRegion.registerTime ne '합계' && status.first}">
                            <tr>
                                <td class="borderNone"></td>
                                <td style="border: 0.5pt solid black;">합계</td>
                                <td style="border: 0.5pt solid black;">-</td>
                                <td style="border: 0.5pt solid black;">-</td>
                                <td style="border: 0.5pt solid black;">-</td>
                                <td style="border: 0.5pt solid black;">-</td>
                                <td style="border: 0.5pt solid black;">-</td>
                                <td style="border: 0.5pt solid black;">-</td>
                                <td style="border: 0.5pt solid black;">-</td>
                                <td style="border: 0.5pt solid black;">-</td>
                            </tr>
                        </c:if>
                        <tr>
                            <td class="borderNone"></td>
                            <c:choose>
                                <c:when test="${resultByRegion.registerTime eq '합계'}">
                                    <td style="border: 0.5pt solid black;">${resultByRegion.registerTime}</td>
                                </c:when>
                                <c:when test="${resultByRegion.registerTime eq '06:00 ~ 09:00'}">
                                    <td style="border: 0.5pt solid black;">오전<br style="mso-data-placement: same-cell">${resultByRegion.registerTime}</td>
                                </c:when>
                                <c:when test="${resultByRegion.registerTime eq '11:00 ~ 17:00'}">
                                    <td style="border: 0.5pt solid black;">오후<br style="mso-data-placement: same-cell">${resultByRegion.registerTime}</td>
                                </c:when>
                                <c:otherwise>
                                    <td style="border: 0.5pt solid black;">야간<br style="mso-data-placement: same-cell">${resultByRegion.registerTime}</td>
                                </c:otherwise>
                            </c:choose>
                            <td style="border: 0.5pt solid black;">${resultByRegion.userReg}</td>
                            <td style="border: 0.5pt solid black;">${resultByRegion.totalUserRegSmell}</td>
                            <td style="border: 0.5pt solid black;">${resultByRegion.smellPercentage}%</td>
                            <td style="border: 0.5pt solid black;">${resultByRegion.smellLevel1}</td>
                            <td style="border: 0.5pt solid black;">${resultByRegion.smellLevel2}</td>
                            <td style="border: 0.5pt solid black;">${resultByRegion.smellLevel3}</td>
                            <td style="border: 0.5pt solid black;">${resultByRegion.smellLevel4}</td>
                            <td style="border: 0.5pt solid black;">${resultByRegion.smellLevel5}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
    <table class="statisticTable">
        <caption>&lt; ${userRegionDetailName}-주요 취기별 악취강도(회) &gt;</caption>
        <tr class="statisticTableTh">
            <td class="borderNone"></td>
            <th rowspan="2" colspan="2">구분</th>
            <th colspan="5">악취강도</th>
        </tr>
        <tr class="statisticTableTh">
            <td class="borderNone"></td>
            <th>1도</th>
            <th>2도</th>
            <th>3도</th>
            <th>4도</th>
            <th>5도</th>
        </tr>
        <c:forEach items="${resultListDetail}" var="resultListByRegionDetail" varStatus="status">
            <c:if test="${resultListByRegionDetail.smellType ne '합계' && status.first}">
                <tr>
                    <td class="borderNone"></td>
                    <td style="border: 0.5pt solid black;">합계</td>
                    <td style="border: 0.5pt solid black;">-</td>
                    <td style="border: 0.5pt solid black;">-</td>
                    <td style="border: 0.5pt solid black;">-</td>
                    <td style="border: 0.5pt solid black;">-</td>
                    <td style="border: 0.5pt solid black;">-</td>
                    <td style="border: 0.5pt solid black;">-</td>
                </tr>
            </c:if>
            <tr>
                <td class="borderNone"></td>
                <td style="border: 0.5pt solid black;">${resultListByRegionDetail.smellType}</td>
                <td style="border: 0.5pt solid black;">${resultListByRegionDetail.totalUserRegSmell}</td>
                <td style="border: 0.5pt solid black;">${resultListByRegionDetail.smellLevel1}</td>
                <td style="border: 0.5pt solid black;">${resultListByRegionDetail.smellLevel2}</td>
                <td style="border: 0.5pt solid black;">${resultListByRegionDetail.smellLevel3}</td>
                <td style="border: 0.5pt solid black;">${resultListByRegionDetail.smellLevel4}</td>
                <td style="border: 0.5pt solid black;">${resultListByRegionDetail.smellLevel5}</td>
            </tr>
        </c:forEach>
    </table>
        </c:otherwise>
    </c:choose>
