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

    <!-- 환경별 다른 카카오 앱키 세팅 -->
    <spring:eval expression="@environment.getProperty('environment')" var="environment" />
    <spring:eval expression="@environment.getProperty('${environment}.kakaoMapKey')" var="kakaoMapKey" />

    <!-- KakaoMap 카카오 앱키 세팅 -->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapKey}"></script>

    <script type="text/javascript">
        var contextPath = '${pageContext.request.contextPath}';
        $.ajaxSetup({cache: false});	//아작스 2번호출을 위한 캐쉬 설정
        //비밀번호 길이 체크
      function fn_chkPwLength(pw){

          if (pw.length < 4 || pw.length > 20) {
              alert("비밀번호는 4 ~ 20 자리로 입력해주세요.");
               $('#userPassword').val('');//비밀번호 입력 초기화
               $('#userPasswordConfirm').val('');//비밀번호 확인 입력 초기화
              return false;
          }
          return true;
      }

      //아이디 길이 체크
      function fn_chkIdLength(id){
          if (id.length < 4 || id.length > 15) {
              alert("아이디는 4 ~ 20 자리로 입력해주세요.");
              $('#userId').val('');//아이디 입력 초기화
              return false;
          }
          return true;
      }

      //로딩바 표시/제거
      function showLoader(show) {
        if(show){
            $("#loader").show();
        }
        else $("#loader").hide();
      }


    //아이디 정규식
    function fn_chkId_pattern(val){

        var regExp = /^[a-z]+[a-z0-9]{3,19}$/g;

        if (!regExp.test(val)) {
            //alert("아이디는 영문 및 숫자 4 ~ 20 자리로 입력해주세요.");
            $('#userId').val('');//아이디 입력 초기화
            return false;
        }
        return true;
    }

    //비밀번호 정규식
    function fn_chkPw_pattern(val) {

        var regExp = /^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{3,19}$/;

        if (!regExp.test(val)) {
            //alert("비밀번호는 영문, 숫자, 특수문자를 최소 한가지씩 4 ~ 20 자리로 입력해주세요.");
            $('#userPassword').val('');//비밀번호 입력 초기화
            $('#userPasswordConfirm').val('');//비밀번호 확인 입력 초기화
            return false;
        }
        return true;
    }

    //휴대폰번호 정규식
    function fn_chkNumber_pattern(val) {

        var regExp =  /^\d{3}\d{3,4}\d{4}$/;
        if (!regExp.test(val)) {
            return false;
        }
        return true;
    }
    </script>