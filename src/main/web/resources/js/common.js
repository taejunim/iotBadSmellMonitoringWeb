$(document).ready(function () {

    $.datepicker.setDefaults({
        dateFormat: 'yy-mm-dd',	//날짜 포맷이다. 보통 yy-mm-dd 를 많이 사용하는것 같다.
        prevText: '이전 달',	// 마우스 오버시 이전달 텍스트
        nextText: '다음 달',	// 마우스 오버시 다음달 텍스트
        closeText: '닫기', // 닫기 버튼 텍스트 변경
        currentText: '오늘', // 오늘 텍스트 변경
        monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],	//한글 캘린더중 월 표시를 위한 부분
        monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],	//한글 캘린더 중 월 표시를 위한 부분
        dayNames: ['일', '월', '화', '수', '목', '금', '토'],	//한글 캘린더 요일 표시 부분
        dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],	//한글 요일 표시 부분
        dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],	// 한글 요일 표시 부분
        showMonthAfterYear: true,	// true : 년 월  false : 월 년 순으로 보여줌
        yearSuffix: '년',	//
        showButtonPanel: true	// 오늘로 가는 버튼과 달력 닫기 버튼 보기 옵션
    });


    //달력 이미지 클릭 시 datepicker 나옴
/*    $(document).on("click", ".dateTimeImg", function () {
        $(this).parent().find("input").focus();
    });*/

});

$(function () {
    var getLabel = $(".tableLabel");
    $(getLabel).each(function (idx, obj) {
        if($(obj).text().indexOf('*') != -1){
            var $span = "<span style='color:#c0392b; font-weight: bold; vertical-align: middle;'>*</span>";

            var getText = $(obj).text();

            getText = getText.replaceAll("*","");

            $(obj).text(getText);
            $(obj).prepend($span);
        }
    })
});

//풍향 코드로 풍향 구하기
function getWindDirectionName(code){
    var name = "";
    switch (code) {
        case "N" : name = "북"; break;
        case "NNE" : name = "북북동"; break;
        case "NE" : name = "북동"; break;
        case "ENE" : name = "동북동"; break;
        case "E" : name = "동"; break;
        case "ESE" : name = "동남동"; break;
        case "SE" : name = "남동"; break;
        case "SSE" : name = "남남동"; break;
        case "S" : name = "남"; break;
        case "SSW" : name = "남남서"; break;
        case "SW" : name = "남서"; break;
        case "WSW" : name = "서남서"; break;
        case "W" : name = "서"; break;
        case "WNW" : name = "서북서"; break;
        case "NW" : name = "북서"; break;
        case "NNW" : name = "북북서"; break;
    }
    return name;
}
