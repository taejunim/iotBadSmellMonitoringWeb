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

        $(".datepicker").datepicker({
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            dateFormat: 'MM yy',
            onClose: function(dateText, inst) {
                var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
                var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                $(this).val($.datepicker.formatDate('MM yy', new Date(year, month, 1)));
            }
        });

        $("#type").change(function(){
            setSearchCondition();
        });
        setSearchCondition();

        var data = [
            ['x', '2021-06-01', '2021-06-02', '2021-06-03', '2021-06-04'],
            ['${CG_SMT[0].codeIdName}' ,30, 20, 10, 4], //64
            ['${CG_SMT[1].codeIdName}' , 10, 15, 14, 2], //41
            ['${CG_SMT[2].codeIdName}' , 4, 15, 10, 7], //36
            ['${CG_SMT[3].codeIdName}' , 1, 7, 11, 20],  //39
            ['${CG_SMT[4].codeIdName}' , 7, 1, 30, 4], //42
            ['${CG_SMT[5].codeIdName}' , 8, 9, 14, 19] //50  272
        ];

        drawChart(data);

    });

    function drawChart(data){

        $.ajax({
            url: "/statisticListSelect",
            type: "POST",
            dataType: "json",
            data: {
                searchGbn : "day",
                searchStart : '2021-06-01',
                searchEnd :  '2021-06-21'

            },
            success: function (data) {
                arrays = data;
                console.log(data);
            },
            error: function (err) {
                alert("사용자 데이터를 불러오는중 에러가 발생하였습니다.");
            }
        });



        var chart1 = c3.generate({
            bindto: '#lineChartDiv'
            ,data: {
                x: 'x'
                ,columns: data
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
                    type : 'timeseries',
                    tick: {
                        format: '%Y-%m-%d'
                    }
                }
            }

        });
        var chart2 = c3.generate({
            pie: {
                title: "Usage " // How to do? style("color", "#59C2E6")
            },
            bindto: '#pieChartDiv',
            data: {
                // iris data from R
                columns: data.splice(1),
                type : 'pie'
            }
        });

        chart1.resize({height:600})
        chart2.resize({height:600})
    }

    function setSearchCondition(showDatePicker){

        var date = new Date();


        if($("#type").val() == "today"){
            $(".dateInput").css("display","none");
            $(".timeInput").css("display","");
            $(".monthInput").css("display","none");
            $(".yearInput").css("display","none");
        } else if($("#type").val() == "day"){
            $(".dateInput").css("display","");
            $(".timeInput").css("display","none");
            $(".monthInput").css("display","none");
            $(".yearInput").css("display","none");
        } else if($("#type").val() == "month"){
            $(".dateInput").css("display","none");
            $(".timeInput").css("display","none");
            $(".monthInput").css("display","");
            $(".yearInput").css("display","none");
        } else if($("#type").val() == "year"){
            $(".dateInput").css("display","none");
            $(".timeInput").css("display","none");
            $(".monthInput").css("display","none");
            $(".yearInput").css("display","");

            var year = date.getFullYear();
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
            <td class="wd210" >
                <select id="region" class="wd100">
                    <option>전체</option>
                    <c:forEach var="item" items="${CG_RGN}">
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
                <div class="timeInput"><select class="wd200">
                    <option>전체</option>
                    <c:forEach var="item" items="${CG_REN}">
                        <option value="${item.codeId}">${item.codeIdName}</option>
                    </c:forEach>
                </select> ~
                <select class="wd200">
                    <option>전체</option>
                    <c:forEach var="item" items="${CG_REN}">
                        <option value="${item.codeId}">${item.codeIdName}</option>
                    </c:forEach>
                </select>
                </div>
                <div class="monthInput"><select class="wd200">
                    <option>전체</option>
                </select> ~
                    <select class="wd200">
                    </select>
                </div>
                <div class="yearInput">
                    <select class="wd200">
                    </select> ~
                    <select class="wd200">
                    </select>
                </div>
            </td>
            <td><a class="button bgcSkyBlue mt10 fr"><i class="bx bx-search"></i>조회</a></td>
        </tr>
    </table>
    <div id="leftSide" class="dp_inlineBlock" style="width: 55%; height: 100%;">
        <h2 id="pieChartTitle" class="title align_c">전체</h2>
        <div id="pieChartDiv"></div>
    </div>
    <div id="rightSide" class="fr scroll_h" style="width:45%;">
        <div id="lineChartDiv"></div>
    </div>
</div>
</body>
</html>
