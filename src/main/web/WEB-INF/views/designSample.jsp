<!--
  Created by IntelliJ IDEA.
  User: guava
  Date: 2021/05/27
  Time: 9:49 오전
  To change this template use File | Settings | File Templates.
-->
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script type="text/javascript">

  $(document).ready(function () {
    userId = "admin";
    setDatePicker();
    setButton("myPage");
  });

  function setDatePicker(){

    //datepicker 초기화 START
    $('#datePicker').datepicker();

/*    $('#searchStartDt').datepicker("option", "maxDate", $("#searchEndDt").val());
    $('#searchStartDt').datepicker("option", "onClose", function ( selectedDate ) {
      $("#searchEndDt").datepicker( "option", "minDate", selectedDate );
    });

    $('#searchEndDt').datepicker();
    $('#searchEndDt').datepicker("option", "minDate", $("#searchStartDt").val());
    $('#searchEndDt').datepicker("option", "onClose", function ( selectedDate ) {
      $("#searchStartDt").datepicker( "option", "maxDate", selectedDate );
    });*/
    //datepicker 초기화 END
  }
</script>
<body>
<jsp:include page="/menu"/>
<table class="searchTable">
  <tr>
    <th>등록자</th><td><input type="text" placeholder="test"></td>
    <th>등록일</th><td><input type="date" class="mDateTimeInput" id="datePicker" readonly="readonly"></td>
    <th>항목1</th><td><select><option>1</option></select></td>
    <th>항목2</th><td><select><option>1</option></select></td>
    <td><a class="button bgcSkyBlue mt10 fr"><i class="bx bx-search"></i>조회</a></td>
  </tr>
</table>
<h2><strong>디자인</strong>샘플</h2>
  <input type="text" placeholder="test">
  <input type="password" placeholder="test">
  <a class="button bgcDeepBlue"><i class="bx bxs-save"></i><strong>저장</strong></a>
  <a class="button bgcDeepRed"><i class="bx bx-minus-circle"></i>삭제</a>
  <a class="button bgcSkyBlue"><i class="bx bx-search"></i>조회</a>

  <a class="subButton">이미지 삭제</a>

  <select>
    <option>12345</option>
    <option>67890</option>
  </select>
  <br>

<table class="blueForm wd450">
  <tr><th colspan="2">회원가입</th></tr>
  <tr><td class="align_l pl20"><label class="tableLabel">* 아이디</label></td><td><input type="text" placeholder="test" readonly></tr>
  <tr><td class="align_l pl20"><label class="tableLabel">* 비밀번호</label></td><td><input type="text" placeholder="test"></td></tr>
  <tr><td class="align_l pl20"><label class="tableLabel">* 구분</label></td><td><input type="text" placeholder="test"></td></tr>
  <tr><td class="align_l pl20"><label class="tableLabel">* 아이디</label></td><td><input type="text" placeholder="test"></td></tr>
  <tr><td colspan="2"><a class="button bgcDeepBlue wd60"><strong>완료</strong></a></td></tr>
</table>

<table class="listTable wd450">
  <tr><th colspan="2">회원가입</th></tr>
  <tr><td class="align_l pl20"><label class="tableLabel">* 아이디</label></td><td><input type="text" placeholder="test" readonly></tr>
  <tr><td class="align_l pl20"><label class="tableLabel">* 비밀번호</label></td><td><input type="text" placeholder="test"></td></tr>
  <tr><td class="align_l pl20"><label class="tableLabel">* 구분</label></td><td><input type="text" placeholder="test"></td></tr>
  <tr><td class="align_l pl20"><label class="tableLabel">* 아이디</label></td><td><input type="text" placeholder="test"></td></tr>
  <tr><td colspan="2"><a class="button bgcDeepBlue wd60"><strong>완료</strong></a></td></tr>
</table>
  </body>
</html>
