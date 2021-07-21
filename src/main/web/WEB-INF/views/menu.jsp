<script type="text/javascript">

    userId = '<%=(String)session.getAttribute("userId")%>';

    $(document).ready(function () {

        //아이콘, 로고, 메인 Click
        $(".mainButton").click(function(){
            $(location).attr('href', '/main.do');
        });
        //개별접수이력조회 Click
        $("#history").click(function(){
            $(location).attr('href', '/history.do');
        });
        //통계 Click
        $("#statistic").click(function(){
            $(location).attr('href', '/statistic.do');
        });
        //회원관리 Click
        $("#member").click(function(){
            $(location).attr('href', '/member.do');
        });
        //마이페이지 Click -> 임시로 샘플페이지 연결
        $("#myPage").click(function(){
            $(location).attr('href', '/myPage.do');
        });
        //로그아웃 Click
        $("#logout").click(function(){
            if(confirm("로그아웃 하시겠습니까?")) {
                $(location).attr('href', '/login.do');
            }
        });
        //로그아웃 Click
        $("#myId").click(function(){
            $(location).attr('href', '/myPage.do');
        });
    });

    //선택된 화면의 메뉴색 변경
    function setButton(buttonId) {
        $(".subMenu>a").removeClass('selectMenu');
        $("#"+buttonId).addClass('selectMenu');
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
    <a id="history">개별접수이력조회</a>
    <a id="statistic">통계</a>
    <a id="member">회원관리</a>
    <a id="myPage">마이페이지</a>
</div>