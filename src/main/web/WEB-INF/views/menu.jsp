<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script type="text/javascript">

    $(document).ready(function () {
        showLoader(false);
        //아이콘, 로고, 메인 Click
        $(".mainButton").click(function(){
            showLoader(true);
            $(location).attr('href', '/main.do');
        });
        //개별접수이력조회 Click
        $("#history").click(function(){
            showLoader(true);
            $(location).attr('href', '/history.do');
        });
        //그래프 Click
        $("#graph").click(function(){
            showLoader(true);
            $(location).attr('href', '/statistic.do');
        });
        //표 Click
        $("#statistic3").click(function(){
            showLoader(true);
            $(location).attr('href', '/statistic.do');
        });
        //회원정보 Click
        $("#memberInfo").click(function(){
            showLoader(true);
            $(location).attr('href', '/member.do');
        });
        //회원출석상태 Click
        $("#attend").click(function(){
            showLoader(true);
            $(location).attr('href', '/attend.do');
        });
        //공지사항 Click
        $("#notice").click(function(){
            showLoader(true);
            $(location).attr('href', '/notice.do');
        });
        //마이페이지 Click
        $("#myPage").click(function(){
            showLoader(true);
            $(location).attr('href', '/myPage.do');
        });
        //로그아웃 Click
        $("#logout").click(function(){
            if(confirm("로그아웃 하시겠습니까?")) {
                showLoader(true);
                $(location).attr('href', '/login.do');
            }
        });
        //관리자명 Click
        $("#myId").click(function(){
            $(location).attr('href', '/myPage.do');
        });
    });

    //선택된 화면의 메뉴색 변경
    function setButton(buttonId) {
        $(".subMenu>a").removeClass('selectMenu');
        $("#"+buttonId).addClass('selectMenu');
    }

    //선택된 드롭다운 메뉴색 변경
    function setDropButton(buttonId) {
        $(".subMenu>a").removeClass('selectDropMenu');
        $("#"+buttonId).addClass('selectDropMenu');
    }

</script>
<div class="wd100rate h100 mainMenu">
    <div class="titleIcon wd80 h80 fl ml10 mt15 mainButton"></div>
    <label class="fl mt50 font_size25 font_bold ml20 mainButton cursor_pointer">IoT 악취 모니터링 시스템</label>
    <a id="logout" class="fr mt70 wd120 align_c cursor_pointer">로그아웃</a>
    <div class="fr mt70 align_c">|</div>
    <a id="myId" class="fr mt70 wd200 align_c cursor_pointer"><%=(String)session.getAttribute("userName")%> 님 환영합니다</a>
</div>
<div class="wd100rate subMenu">
    <a id="main" class="mainButton"><i class="bx bxs-home lh40 font_size20"></i></a>
    <a id="notice">공지사항</a>
    <a id="history">개별접수이력조회</a>
    <div id="statistic" class="dropdown">
        <a class="dropbtn">통계</a>
        <div class="dropdown-content">
            <a id="graph">그래프</a>
            <a id="statistic3">표</a>
        </div>
    </div>
    <div id="member" class="dropdown">
        <a class="dropbtn">회원관리</a>
        <div class="dropdown-content">
            <a id="memberInfo">회원정보</a>
            <a id="attend">회원 출석 상태</a>
        </div>
    </div>
    <a id="myPage">마이페이지</a>
</div>
<div id="loader" class="loaderContainer">
    <div class="loaderBox">
        <div class="loaderContent"></div>
    </div>
</div>