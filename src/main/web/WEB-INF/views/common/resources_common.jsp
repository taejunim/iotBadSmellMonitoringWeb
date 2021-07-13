<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type"/>

    <title>IoT 악취 모니터링 시스템</title>
    <!-- js -->
    <script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
    <script src="/resources/js/moment.js"></script>
    <script src="/resources/js/common.js"></script>

    <!-- css -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/font.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/boxicons.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/iotBadSmellMonitoring.css">

    <!-- jquery -->
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

    <!-- KakaoMap 서버 반영용-->
    <%--<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4bcfea95a6c0fea34615b3ea4d5dd430"></script>--%>
    <!-- KakaoMap 테스트 서버 반영용-->
    <%--<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3b4561dd700f64e8fa55b3ced036b82e"></script>--%>
    <!-- KakaoMap 개발용-->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=31eb4881990129126e189d5ee4ed5f3e"></script>

    <script type="text/javascript">
        var contextPath = '${pageContext.request.contextPath}';
        $.ajaxSetup({cache: false});	//아작스 2번호출을 위한 캐쉬 설정
    </script>