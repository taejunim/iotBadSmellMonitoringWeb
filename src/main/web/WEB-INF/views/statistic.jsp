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

        //세션값 바로 가져오는 예제
        console.log('<%=(String)session.getAttribute("userName")%>');
        console.log('<%=(String)session.getAttribute("userPassword")%>');
        
        $("#type").change(function(){
            setSearchCondition();
        });
        setSearchCondition();
        //var x = ['x','07:00~09:00','12:00~14:00' , '18:00~20:00' ,'22:00~00:00'];
        //var x = ['x','rk','asdf' , 'adsf' ,'adsf'];
        var data = [
                ['x','rk','asdf' , 'adsf' ,'adsf'],
                ['${CG_SMT[0].codeIdName}' ,30, 20, 10, 4],
                ['${CG_SMT[1].codeIdName}' , 10, 15, 14, 2],
                ['${CG_SMT[2].codeIdName}' , 4, 15, 10, 7],
                ['${CG_SMT[3].codeIdName}' , 1, 7, 11, 20],
                ['${CG_SMT[4].codeIdName}' , 7, 1, 30, 4],
                ['${CG_SMT[5].codeIdName}' , 8, 9, 14, 19]
         ];

        drawChart(data);

    });

    function drawChart(data){
/*        var chart = c3.generate({
            bindto: '#chartDiv',
            data: {
                x:'test',
                columns:{
                    json : {
                    test:['rk','asdf' , 'adsf' ,'adsf'],
                    '${CG_SMT[0].codeIdName}':[30, 20, 10, 4],
                    '${CG_SMT[1].codeIdName}':[10, 15, 14, 2],
                    '${CG_SMT[2].codeIdName}':[ 4, 15, 10, 7],
                    '${CG_SMT[3].codeIdName}':[ 1, 7, 11, 20],
                    '${CG_SMT[4].codeIdName}':[ 7, 1, 30, 4],
                    '${CG_SMT[5].codeIdName}':[ 8, 9, 14, 19]
    }
                },
                type:'bar'
            },
            axis:{
                x : {
                    type : 'text'
                }
            }
        });
        */
        var chart = c3.generate({
            bindto: '#chartDiv'
            ,data: {
                x: 'x'
                ,columns: [
                    ['x', '2021-06-01', '2021-06-02', '2021-06-03', '2021-06-04'],
                    ['${CG_SMT[0].codeIdName}' ,30, 20, 10, 4],
                    ['${CG_SMT[1].codeIdName}' , 10, 15, 14, 2],
                    ['${CG_SMT[2].codeIdName}' , 4, 15, 10, 7],
                    ['${CG_SMT[3].codeIdName}' , 1, 7, 11, 20],
                    ['${CG_SMT[4].codeIdName}' , 7, 1, 30, 4],
                    ['${CG_SMT[5].codeIdName}' , 8, 9, 14, 19]
                ]
                ,types: {
                    '${CG_SMT[0].codeIdName}': 'bar'
                    ,'${CG_SMT[1].codeIdName}': 'bar'
                    ,'${CG_SMT[2].codeIdName}': 'bar'
                    ,'${CG_SMT[3].codeIdName}': 'bar'
                    ,'${CG_SMT[4].codeIdName}': 'bar'
                    ,'${CG_SMT[5].codeIdName}': 'bar'
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
        chart.resize({height:600})
    }

    function setSearchCondition(showDatePicker){

        if($("#type").val() == "today"){
            $(".dateInput").css("display","none");
            $(".timeInput").css("display","");
        }else {
            $(".dateInput").css("display","");
            $(".timeInput").css("display","none");
        }
    }
</script>
<body>
<jsp:include page="/menu"/>
<div class="bgc_w wd100rate h100rate fl">
    <table class="searchTable">
        <tr>
            <th class="wd90">구분</th>
            <td class="wd120" >
                <select id="type" class="wd100">
                    <option value="today">당일</option>
                    <option value="day">일별</option>
                    <option value="month">월별</option>
                    <option value="year">연별</option>
                </select>
            </td>
            <td>
                <div class="dateInput" >
                <input type="date"id="startDatePicker" readonly="readonly"> ~
                <input type="date" id="endDatePicker" readonly="readonly"></div>
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
            </td>
            <td><a class="button bgcSkyBlue mt10 fr"><i class="bx bx-search"></i>조회</a></td>
        </tr>
    </table>
    <div id="leftSide" class="dp_inlineBlock" style="width: 55%; height: 100%;">
        <div id="chartDiv"></div>
    </div>
    <div id="rightSide" class="fr scroll_h" style="width:45%;">
        <table class="viewTable">
            <tr>
                <th class="wd5rate">NO</th>
                <th>${CG_SMT[0].codeIdName}</th>
                <th>${CG_SMT[1].codeIdName}</th>
                <th>${CG_SMT[2].codeIdName}</th>
                <th>${CG_SMT[3].codeIdName}</th>
                <th>${CG_SMT[4].codeIdName}</th>
                <th>${CG_SMT[5].codeIdName}</th>
            </tr>
            <tr class="cursor_pointer itemRow">
                <th style="border-top: 0px;">df</th>
                <td>${resultList.userTypeName}</td>
                <td>${resultList.userId}</td>
                <td>${resultList.userName}</td>
                <td>${resultList.userAge}</td>
                <td>${resultList.userSexName}</td>
                <td></td>
            </tr>
        </table>
    </div>
</div>
</body>
</html>
