<%--
  Created by IntelliJ IDEA.
  User: joyuyeong
  Date: 2021/06/08
  Time: 3:27 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script src="/resources/js/kakaoMapUtils.js"></script>
<script src="/resources/js/c3/c3.js"></script>
<script src="/resources/js/c3/d3.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/c3/c3.css">
<script type="text/javascript">
    $(document).ready(function () {
        setButton("statistic");
        setDropButton("graph");     //선택된 드롭다운 메뉴 색상 변경
        $(".datepicker").datepicker();

        $("#type").change(function(){
            setSearchCondition();
        });
        $("#searchBtn").click(function(){
            drawChart();
        });

        setSearchCondition();
        drawChart();

    });

    function drawChart(){

        //차트 그릴 배열 초기화
        var arrays = [['x'],['${CG_SMT[0].codeIdName}'],['${CG_SMT[1].codeIdName}'],['${CG_SMT[2].codeIdName}'],['${CG_SMT[3].codeIdName}'],['${CG_SMT[4].codeIdName}'],['${CG_SMT[5].codeIdName}']];

        var searchGbn = $("#type").val();
        var userRegionMaster = $("#userRegionMaster").val();
        var userRegionDetail = $("#userRegionDetail").val();
        var searchStart = "";
        var searchEnd   = "";
        var tickFormat  = "";
        var xAxisText   = "";

        if(searchGbn == "day" ) {           //일별
            searchStart = $("#startDatePicker").val();
            searchEnd = $("#endDatePicker").val();
            tickFormat = "%Y-%m-%d";
            xAxisText = "일";
        } else if(searchGbn == "month" ) {  //월별
            searchStart = $("#startYearSelect").val() + "-" + $("#startMonthSelect").val();
            searchEnd = $("#endYearSelect").val() + "-" + $("#endMonthSelect").val();
            xAxisText = "월";
        } else if(searchGbn == "year" ) {   //연별
            searchStart = $("#startYearInput").val();
            searchEnd = $("#endYearInput").val();
            xAxisText = "년";
        } else {                            //당일
            searchStart = $("#startTimeInput").val();
            searchEnd = $("#endTimeInput").val();
            xAxisText = "시간대";
        }

        //검색 조건 유효성 체크
        if(searchStart > searchEnd) return alert("검색조건을 다시 확인하여 주십시오. 검색 시작 시간은 검색 종료 시간을 초과할수 없습니다.");

        showLoader(true);
        $.ajax({
            url: "/statisticListSelect",
            type: "POST",
            dataType: "json",
            data: {
                searchGbn   : searchGbn,
                searchStart : searchStart,
                searchEnd   :  searchEnd,
                userRegionMaster      : userRegionMaster,
                userRegionDetail      : userRegionDetail
            },
            success: function (data) {

                //해당 조건에 데이터가 없을때
                if (data.length == 0) {
                    $(".noChartContent").css("display","");
                    $(".chartContent").css("display","none");
                    alert("해당 기간에 데이터가 존재하지 않습니다. 검색 조건을 다시 지정하여 주십시오.");
                } else { // 데이터가 있을때
                    $(".noChartContent").css("display","none");
                    $(".chartContent").css("display","");
                    var yType = "category";

                    if (searchGbn == "day") yType = "timeseries";

                    for(var i = 0; i < data.length; i++){

                        arrays[parseInt(data[i].smellValue)].push(data[i].cnt);

                        if( arrays[0][arrays[0].length - 1] != data[i].regDt){
                            arrays[0].push(data[i].regDt);
                        }

                        if(i == data.length - 1 || data[i].regDt != data[i+1].regDt)  {
                            for(var j = 1 ; j < 7; j++){
                                if( arrays[j].length != arrays[0].length){
                                    arrays[j].push(0);}
                            }
                        }
                    }

                    var chart1 = c3.generate({
                        bindto: '#lineChartDiv'
                        ,data: {
                            x: 'x'
                            ,columns: arrays
                            ,types: {
                                '${CG_SMT[0].codeIdName}': 'line'
                                ,'${CG_SMT[1].codeIdName}': 'line'
                                ,'${CG_SMT[2].codeIdName}': 'line'
                                ,'${CG_SMT[3].codeIdName}': 'line'
                                ,'${CG_SMT[4].codeIdName}': 'line'
                                ,'${CG_SMT[5].codeIdName}': 'line'
                            }
                            ,colors: {
                                 '${CG_SMT[0].codeIdName}': '#61ade1'
                                ,'${CG_SMT[1].codeIdName}': '#23cc71'
                                ,'${CG_SMT[2].codeIdName}': '#bbbbbb'
                                ,'${CG_SMT[3].codeIdName}': '#fff800'
                                ,'${CG_SMT[4].codeIdName}': '#f39c12'
                                ,'${CG_SMT[5].codeIdName}': '#c0392b'
                            }
                        }
                        ,axis : {
                            x : {
                                type: yType,
                                tick: {
                                    format: tickFormat
                                },
                                label: {
                                    text: xAxisText,
                                    position: 'outer-middle'
                                }
                            },
                            y : {
                                min : 0,
                                padding: {bottom: 0},
                                label: {
                                    text: '건 수',
                                    position: 'outer-top',
                                    rotate: 90
                                },
                                tick: {
                                    format: function (d) {
                                        return (parseInt(d) == d) ? d : null;
                                    }
                                }
                            }
                        }
                    });
                    var chart2 = c3.generate({
                        pie: {
                            title : "Usage "
                        },
                        bindto: '#pieChartDiv',
                        data: {
                            columns: arrays.splice(1),
                            type : 'pie',
                            colors: {
                                '${CG_SMT[0].codeIdName}': '#61ade1'
                                ,'${CG_SMT[1].codeIdName}': '#23cc71'
                                ,'${CG_SMT[2].codeIdName}': '#bbbbbb'
                                ,'${CG_SMT[3].codeIdName}': '#fff800'
                                ,'${CG_SMT[4].codeIdName}': '#f39c12'
                                ,'${CG_SMT[5].codeIdName}': '#c0392b'
                            }
                        }
                    });
                    //새로 그릴떄마다 resize 해줘야함.
                    chart1.resize({height:600})
                    chart2.resize({height:600})
                    $("#pieChartTitle").text($("#userRegionMaster option:selected").text()+" "+$("#userRegionDetail option:selected").text());
                }
            },
            error: function (err) {
                alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
            }
        }).done(function(){
            showLoader(false);
        });
    }

    //기간 조건 바뀔때마다 select box 바꿔주고, 오늘날짜 기준으로 초기화
    function setSearchCondition(){

        var date = new Date();

        if($("#type").val() == "today"){
            $(".dateInput").css("display","none");
            $(".timeInput").css("display","");
            $(".monthInput").css("display","none");
            $(".yearInput").css("display","none");

            $("#startTimeInput option:first").attr("selected","selected");
            $("#endTimeInput option:last").attr("selected","selected");

        } else if($("#type").val() == "day"){
            $(".dateInput").css("display","");
            $(".timeInput").css("display","none");
            $(".monthInput").css("display","none");
            $(".yearInput").css("display","none");

            var month = date.getMonth() + 1;
            if(month < 10) month = "0" + month;
            var day = date.getDate();
            if(day < 10) day = "0" + day;
            $(".datepicker").val(date.getFullYear() + "-" + month+ "-" + day);

        } else if($("#type").val() == "month"){
            $(".dateInput").css("display","none");
            $(".timeInput").css("display","none");
            $(".monthInput").css("display","");
            $(".yearInput").css("display","none");

            var year = date.getFullYear();
            $(".monthYearSelect").empty();
            for(var i=0; i<=10; i++){
                $(".yearSelect").append("<option value='"+ (year - i) +"'>"+(year - i) +"년"+"</option>");
            }
            for(var i=1; i<=12; i++){
                if(i < 10) $(".monthSelect").append("<option value='0"+ i +"'>0"+i +"월"+"</option>");
                else $(".monthSelect").append("<option value='"+ i +"'>"+i +"월"+"</option>");
            }
            var month = date.getMonth() + 1;
            if(month < 10) month = "0" + month;
            $(".monthSelect").val(month);

        } else if($("#type").val() == "year"){
            $(".dateInput").css("display","none");
            $(".timeInput").css("display","none");
            $(".monthInput").css("display","none");
            $(".yearInput").css("display","");

            var year = date.getFullYear();
                $(".yearInput select").empty();
            for(var i=0; i<=10; i++){
                $(".yearInput select").append("<option value='"+ (year - i) +"'>"+(year - i) +"년"+"</option>");
            }
        }
    }
</script>
<body>
<jsp:include page="/menu"/>
<div class="bgc_w wd100rate h100rate fl">
    <table class="searchTable">
        <tr>
            <th class="wd90">구분</th>
            <td class="wd350" >
                <select id="userRegionMaster" class="wd100">
                    <option value="">전체</option>
                    <c:forEach var="item" items="${CG_REM}">
                        <option value="${item.codeId}">${item.codeIdName}</option>
                    </c:forEach>
                </select>
                <select id="userRegionDetail" class="wd100">
                    <option value="">전체</option>
                    <c:forEach var="item" items="${CG_RGD}">
                        <option value="${item.codeId}">${item.codeIdName}</option>
                    </c:forEach>
                </select>
                <select id="type" class="wd100">
                    <option value="today">당일</option>
                    <option value="day">일별</option>
                    <option value="month">월별</option>
                    <option value="year">연별</option>
                </select>
            </td>
            <td>
                <div class="dateInput" >
                <input type="date"id="startDatePicker" class= "datepicker" readonly="readonly"> ~
                <input type="date" id="endDatePicker" class="datepicker" readonly="readonly"></div>
                <div class="timeInput"><select class="wd200" id="startTimeInput">
                    <c:forEach var="item" items="${CG_REN}">
                        <option value="${item.codeId}">${item.codeIdName}</option>
                    </c:forEach>
                </select> ~
                <select class="wd200" id="endTimeInput">
                    <c:forEach var="item" items="${CG_REN}">
                        <option value="${item.codeId}">${item.codeIdName}</option>
                    </c:forEach>
                </select>
                </div>
                <div class="monthInput">
                    <select class="wd100 monthYearSelect yearSelect" id="startYearSelect">
                    </select>
                    <select class="wd100 monthYearSelect monthSelect" id="startMonthSelect">
                    </select>
                    ~
                    <select class="wd100 monthYearSelect yearSelect" id="endYearSelect">
                    </select>
                    <select class="wd100 monthYearSelect monthSelect" id="endMonthSelect">
                    </select>
                </div>
                <div class="yearInput">
                    <select class="wd200" id="startYearInput">
                    </select> ~
                    <select class="wd200" id="endYearInput">
                    </select>
                </div>
            </td>
            <td><a class="button bgcSkyBlue mt10 fr" id="searchBtn"><i class="bx bx-search"></i>조회</a></td>
        </tr>
    </table>
    <div id="leftSide" class="dp_inlineBlock borderRight" style="width: 54%; height: 100%;">
        <h2 id="pieChartTitle" class="title align_c chartContent" style="display: none;">전체</h2>
        <div id="pieChartDiv" class="chartContent" style="display: none;"></div>
        <div class="noChartContent wd100rate h100rate align_c" style="display: none; position:relative; top:300px;">- 표시할 내용이 없습니다. -</div>
    </div>
    <div id="rightSide" class="fr scroll_h mt50" style="width:45%;">
        <div id="lineChartDiv" class="chartContent" style="display: none; width: 90%;"></div>
        <div class="noChartContent wd100rate h100rate align_c" style="display: none; position:relative; top:250px;">- 표시할 내용이 없습니다. -</div>
    </div>
</div>
</body>
</html>
