<!--
Created by IntelliJ IDEA.
User: guava
Date: 2021/06/02
Time: 9:49 오전
To change this template use File | Settings | File Templates.
-->
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script type="text/javascript">

    $(document).ready(function () {
        userId = "admin";
        setButton("member");
    });
</script>
<body>
<jsp:include page="/menu"/>
<table class="searchTable">
    <tr>
        <th>아이디/이름</th>
        <td><input type="text" placeholder="test"></td>
        <th>나이</th>
        <td><input type="text" placeholder="test"></td>
        <th>성별</th>
        <td>
            <select>
                <option>전체</option>
                <option>남성</option>
                <option>여성</option>
            </select>
        </td>
        <th>구분</th>
        <td>
            <select>
                <option>전체</option>
                <option>관리자</option>
                <option>일반</option>
            </select>
        </td>
        <td><a class="button bgcSkyBlue mt10 fr"><i class="bx bx-search"></i>조회</a></td>
    </tr>
</table>

<div class="wd100rate h100rate bgc_w">

    <div class="wd70rate h100rate fl brDeepBlue">
        <table class="wd80rate viewTable">
            <tr>
                <th class="wd5rate">NO</th>
                <th>구분</th>
                <th>아이디</th>
                <th>이름</th>
                <th>나이</th>
                <th>성별</th>
                <th class="wd20rate">등록일시</th>
            </tr>
            <tr>
                <td>1</td>
                <td>일반</td>
                <td>test</td>
                <td>이름1</td>
                <td>나이</td>
                <td>성별</td>
                <td>등록일시</td>
            </tr>
            <tr>
                <td>2</td>
                <td>관리자</td>
                <td>system</td>
                <td>이름</td>
                <td>나이</td>
                <td>성별</td>
                <td>등록일시</td>
            </tr>
            <tr>
                <td>3</td>
                <td>일반</td>
                <td>test</td>
                <td>이름1</td>
                <td>나이</td>
                <td>성별</td>
                <td>등록일시</td>
            </tr>
            <tr>
                <td>4</td>
                <td>관리자</td>
                <td>system</td>
                <td>이름</td>
                <td>나이</td>
                <td>성별</td>
                <td>등록일시</td>
            </tr>
            <tr>
                <td>5</td>
                <td>일반</td>
                <td>test</td>
                <td>이름1</td>
                <td>나이</td>
                <td>성별</td>
                <td>등록일시</td>
            </tr>
            <tr>
                <td>6</td>
                <td>관리자</td>
                <td>system</td>
                <td>이름</td>
                <td>나이</td>
                <td>성별</td>
                <td>등록일시</td>
            </tr>
            <tr>
                <td>7</td>
                <td>일반</td>
                <td>test</td>
                <td>이름1</td>
                <td>나이</td>
                <td>성별</td>
                <td>등록일시</td>
            </tr>
            <tr>
                <td>8</td>
                <td>관리자</td>
                <td>system</td>
                <td>이름</td>
                <td>나이</td>
                <td>성별</td>
                <td>등록일시</td>
            </tr>
            <tr>
                <td>9</td>
                <td>일반</td>
                <td>test</td>
                <td>이름1</td>
                <td>나이</td>
                <td>성별</td>
                <td>등록일시</td>
            </tr>
            <tr>
                <td>10</td>
                <td>관리자</td>
                <td>system</td>
                <td>이름</td>
                <td>나이</td>
                <td>성별</td>
                <td>등록일시</td>
            </tr>
        </table>
        <div style="width: 100%;height: 30px; border: 1px solid #5E2FD8;"> 페이징</div>
    </div>

    <div class="h100rate fr wd28rate">
        <h2 class="mt50"><strong>회원정보</strong></h2>
        <table class="listTable wd450">
            <tr class="h57">
                <td class="align_l"><label>아이디</label></td>
                <td><input type="text" placeholder="test" readonly>
            </tr>
            <tr class="h57">
                <td class="align_l"><label>비밀번호</label></td>
                <td><input type="password" class="wd48rate"></td>
            </tr>
            <tr class="h57">
                <td class="align_l"><label>이름</label></td>
                <td><input type="text" readonly></td>
            </tr>
            <tr class="h57">
                <td class="align_l"><label>나이</label></td>
                <td><input type="text" readonly></td>
            </tr>
            <tr class="h57">
                <td class="align_l"><label>성별</label></td>
                <td>
                    <select class="wd65rate" readonly>
                        <option>남성</option>
                        <option>여성</option>
                    </select>
            </tr>
            <tr class="h57">
                <td class="align_l"><label>구분</label></td>
                <td>
                    <select class="wd65rate" readonly>
                        <option>관리자</option>
                        <option>일반</option>
                    </select>
            </tr>
            <tr class="h80">
                <td colspan="2" class="align_c">
                    <a class="button bgcDeepBlue"><i class="bx bxs-save"></i><strong>저장</strong></a>
                    <a class="button bgcDeepRed"><i class="bx bx-minus-circle"></i>탈퇴</a>
                </td>
            </tr>
        </table>
    </div>

</div>
</body>
</html>
