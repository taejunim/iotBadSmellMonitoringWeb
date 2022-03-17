<%@ page language="java" contentType="application/vnd.ms-excel;" pageEncoding="UTF-8"%>
<meta http-equiv="content-type" content="application/vnd.ms-excel; charset=utf-8">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<%
    String filename = new String("주민_악취_모니터링_결과_통계".getBytes(), "8859_1");
    response.setHeader("Content-Disposition", "attachment; filename="+ filename + ".xls");
    response.setHeader("Content-Description", "JSP Generated Data");
%>
    <table>
        <tr>
            <td></td>
            <td colspan="5">
            주민참여형 악취모니터링 결과(${statisticTableVO.searchStart} ~ ${statisticTableVO.searchEnd})
            </td>
        </tr>
    </table>
    <c:set var="result" value="${result}"/>
    <table class="statisticTable">
        <thead>
            <tr>
                <th colspan="2" class="statisticTableVerticalTh">구분</th><th>총 입력 횟수</th><th>감지횟수</th><th>감지비율(%)</th><th>주요 감지<br/>악취강도<br/>(단위 : 도)</th><th>주요 냄새</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <th colspan="2" class="statisticTableVerticalTh">합계</th>
                <td>${result.userTotalCount}</td>
                <td>${result.userRegisterCount}</td>
                <td>${result.userRegisterPercentage}</td>
                <td>${result.mainSmellValueName}</td>
                <td>${result.mainSmellTypeName}</td>
            </tr>
            <c:forEach var="subItem" items="${result.list}" varStatus="status">
                <c:set var="listItem" value="${result.list.get(status.index)}"/>
                <tr>
                    <th class="userRegionMaster statisticTableVerticalTh">${listItem.userRegionMasterName}</th>
                    <th class="statisticTableVerticalTh">${listItem.userRegionDetailName}</th>
                    <td>${listItem.userTotalCount}</td>
                    <td>${listItem.userRegisterCount}</td>
                    <td>${listItem.userRegisterPercentage}</td>
                    <td>${listItem.mainSmellValueName}</td>
                    <td>${listItem.mainSmellTypeName}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>