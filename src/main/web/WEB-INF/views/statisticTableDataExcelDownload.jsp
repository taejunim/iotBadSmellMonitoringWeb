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
        .statisticTable td{
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
        }
    </style>
<%
    String filename = new String("주민_악취_모니터링_결과_통계".getBytes(), "8859_1");
    response.setHeader("Content-Disposition", "attachment; filename="+ filename + ".xls");
    response.setHeader("Content-Description", "JSP Generated Data");
%>
    <table>
        <tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>
        <tr>
            <td></td>
            <td class="resultLabel" colspan="5">
            주민참여형 악취모니터링 결과(${statisticTableVO.searchStart} ~ ${statisticTableVO.searchEnd})
            </td>
        </tr>
        <tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>
    </table>
    <c:set var="result" value="${result}"/>
    <table class="statisticTable">
        <thead>
            <tr>
                <td class="borderNone"></td>
                <td colspan="2">구분</td>
                <td>총 입력 횟수</td>
                <td>감지횟수</td>
                <td>감지비율(%)</td>
                <td>주요 감지<br/>악취강도<br/>(단위 : 도)</td>
                <td>주요 냄새</td>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td class="borderNone"></td>
                <td colspan="2">합계</td>
                <td>${result.userTotalCount}</td>
                <td>${result.userRegisterCount}</td>
                <td>${result.userRegisterPercentage}</td>
                <td>${result.mainSmellValueName eq '' ? '-': result.mainSmellValueName}</td>
                <td>${result.mainSmellTypeNameeq eq '' ? '-': result.mainSmellTypeName}</td>
            </tr>
            <c:forEach var="subItem" items="${result.list}" varStatus="status">
                <c:set var="listItem" value="${result.list.get(status.index)}"/>
                <tr><td class="borderNone"></td>
                <c:choose>
                    <c:when test="${status.index eq 0}">
                        <td rowspan="${regionCountMap.get(listItem.userRegionMaster)}">${listItem.userRegionMasterName}</td>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${listItem.userRegionMaster ne result.list.get(status.index - 1).userRegionMaster}">
                            <td rowspan="${regionCountMap.get(listItem.userRegionMaster)}">${listItem.userRegionMasterName}</td>
                        </c:if>
                    </c:otherwise>
                </c:choose>
                        <td>${listItem.userRegionDetailName}</td>
                        <td>${listItem.userTotalCount}</td>
                        <td>${listItem.userRegisterCount}</td>
                        <td>${listItem.userRegisterPercentage}</td>
                        <td>${listItem.mainSmellValueName eq '' ? '-': listItem.mainSmellValueName}</td>
                        <td>${listItem.mainSmellTypeName eq '' ? '-': listItem.mainSmellTypeName}</td>
                    </tr>
            </c:forEach>
        </tbody>
    </table>