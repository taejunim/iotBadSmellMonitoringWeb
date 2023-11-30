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
    var userId      = '${joinVO.userId}';               //검색조건_아이디/이름
    var userRegion  = '${joinVO.userRegionMaster}';     //검색조건_지역
    var userAge     = '${joinVO.userAge}';              //검색조건_나이
    var userSex     = '${joinVO.userSex}';              //검색조건_성별
    var userType    = '${joinVO.userType}';             //검색조건_구분

    function init() {
        location.replace(location.href);
    }

    $(document).ready(function () {
        setButton("member");            //선택된 화면의 메뉴색 변경 CALL
        setDropButton("memberInfo");    //선택된 드롭다운 메뉴색 변경 CALL
        hideList();                             //회원 선택 전 히든처리 CALL.

        /* 검색 화면 검색어 세팅 START*/
        if (userRegion != "" && userRegion != null)                         //지역
            $("#searchUserRegion").val(userRegion).prop("selected", true);
        if (userSex != "" && userSex != null)                               //성별
            $("#searchUserSex").val(userSex).prop("selected", true);

        if (userType != "" && userType != null)                              //구분
            $("#searchUserType").val(userType).prop("selected", true);
        /* 검색 화면 검색어 세팅 END*/

        /*테이블 row 클릭 이벤트 START*/
        $(".itemRow").click(function () {

            $(this).css('background-color', 'rgb(217,239,255)');                        //선택된 로우 색상 변경
            $(".itemRow").not($(this)).css('background-color', 'rgba(255,255,255,0)');  //선택되지 않은 로우 색상

            var getItems = $(this).find("td");


            $("#userPassword").val("");
            $("#userPasswordConfirm").val("");
            $("#userId").val(getItems.eq(2).text());
            $("#userName").val(getItems.eq(3).text());
            $("#userRegion").val(getItems.eq(4).text());
            $("#userPhone").val(getItems.eq(5).text());
            $("#userAge").val(getItems.eq(6).text());
            $("#userSex").val(getItems.eq(7).text());
            $("#userType").val(getItems.eq(1).text());
            $('#memberStatus').val(getItems.eq(10).text());

            showList();                                         // 회원 선택 시 상세화면 불러오기.

        })
        /*테이블 row 클릭 이벤트 END*/

        /*조회 엔터 이벤트 START*/
        $('input[type="text"]').keydown(function() {
            if (event.keyCode === 13) {
                fn_search();
            };
        });
        /*조회 엔터 이벤트 END*/

        /*승인 버튼 클릭 이벤트 START*/
        $("#memberConfirmBtn").click(function () {
            var userId = $("#userId").val().trim();

            // 회원을 선택 했는지 체크
            if (userId === undefined || userId === "") {
                alert("변경할 회원을 선택해 주세요.");
                return false;
            }
            var con_test;
            if ($("#memberStatus").val().trim() == 'N') {
                alert("거절된 회원은 승인 할 수 없습니다.\n재가입 후 다시 승인 해주시길 바랍니다.")
            } else if ($("#memberStatus").val().trim() == 'Y'){
                alert("이미 승인된 회원입니다.");
                return false;
            } else {
                con_test = confirm(userId + "을(를) 승인하시겠습니까?");
            }

            if (con_test == true) {
                showLoader(true);
                $.ajax({
                    url: "/memberConfirm/",
                    type: "POST",
                    data: {userId: $("#userId").val()},
                    dataType: "text",
                    success: function (data) {
                        alert("승인되었습니다.");
                        init();
                    },
                    error: function (err) {
                        console.log(err);
                        alert("승인에 실패하였습니다.");
                    }
                }).done(function () {
                    showLoader(false);
                });
            }


        })
        /*승인 버튼 클릭 이벤트 END*/
        /*거절 버튼 클릭 이벤트 START*/
        $("#memberRefuseBtn").click(function () {
            var userId = $("#userId").val().trim();
            var status = $("#memberStatus").val().trim();
            // 회원을 선택 했는지 체크
            if (userId === undefined || userId === "") {
                alert("변경할 회원을 선택해 주세요.");
                return false;
            }

            if(status == 'Y') {
                console.log('status : ' + status);
                alert("승인된 사용자는 거절할 수 없습니다.");
                return false;
            } else if (status == 'N') {
                alert("이미 거절된 회원입니다.");
                return false;
            }

            // alert("거절된 회원은 탈퇴 후 다시 가입 시켜주세요.");

            var con_test = confirm(userId + "을(를) 거절하시겠습까?");

            if (con_test == true) {
                showLoader(true);
                $.ajax({
                    url: "/memberRefuse/",
                    type: "POST",
                    data: {userId: $("#userId").val()},
                    dataType: "text",
                    success: function (data) {
                        alert("거절되었습니다.");
                        init();
                    },
                    error: function (err) {
                        console.log(err);
                        alert("거절에 실패하였습니다.");
                    }
                }).done(function () {
                    showLoader(false);
                });
            }


        })
        /*거절 버튼 클릭 이벤트 END*/
        /*저장 버튼 클릭 이벤트 START*/
        $("#memberSaveBtn").click(function () {
            var userId = $("#userId").val().trim();

            // 회원을 선택 했는지 체크
            if (userId === undefined || userId === "") {
                alert("변경할 회원을 선택해 주세요.");
                return false;
            }

            var getPw = $("#userPassword").val().trim();

            //비밀번호 정규식
            if (!fn_chkPw_pattern(getPw)) {
                alert("비밀번호는 영문,숫자,특수문자를 최소 한가지씩 4~20자리로 입력해주세요.");
                $("#userPassword").focus();
                return false;
            }

            //비밀번호 일치 확인
            if (getPw != $("#userPasswordConfirm").val().trim()) {
                alert("비밀번호가 일치하지 않습니다.");
                $("#userPasswordConfirm").focus();
                return false;
            }

            var con_test = confirm($("#userId").val().trim() + "의 비밀번호를 변경하시겠습니까?");

            if (con_test == true) {
                showLoader(true);
                $.ajax({
                    url: "/memberPasswordUpdate/",
                    type: "POST",
                    data: {userPassword: $("#userPassword").val(), userId: $("#userId").val()},
                    dataType: "text",
                    success: function (data) {
                        alert("비밀번호를 변경하였습니다.");
                        $("#userPassword").val("");
                        $("#userPasswordConfirm").val("");
                    },
                    error: function (err) {
                        console.log(err);
                        alert("비밀번호 변경을 실패하였습니다.");
                    }
                }).done(function () {
                    showLoader(false);
                });
            }
        })
        /*저장 버튼 클릭 이벤트 END*/


        /*탈퇴 버튼 클릭 이벤트 START*/
        $("#memberDeleteBtn").click(function () {

            var getUserId = $("#userId").val().trim();

            // 회원을 선택 했는지 체크
            if (getUserId === undefined || getUserId === "") {
                alert("탈퇴할 회원을 선택해 주세요.");
                return false;
            }

            //로그인한 아이디는 탈퇴 X
            if (userId === getUserId) {
                alert("로그인한 계정 탈퇴는 마이페이지에서 진행 가능합니다.");
                return false;
            }

            var con_test = confirm(getUserId + "을(를) 탈퇴시키겠습니까?");

            if (con_test == true) {
                showLoader(true);
                $.ajax({
                    url: "/memberDelete/",
                    type: "POST",
                    data: {userId: $("#userId").val()},
                    dataType: "text",
                    success: function (data) {
                        alert("회원 탈퇴를 성공하였습니다.");
                        fn_page($("#pageIndex").val());
                    },
                    error: function (err) {
                        console.log(err);
                        alert("회원 탈퇴를 실패하였습니다.");
                    }
                }).done(function () {
                    show(false);
                });
            }
        })
        /*탈퇴 버튼 클릭 이벤트 END*/
    });

    function hideList() {
        $("#DetailMemberInfo").hide();
        $("#DetailShow").hide();
        $(".wd28rate").append("<h2 class='selectMember' style='margin: 0 auto; text-align: center; position: relative; top: 37%;'> - 회원을 선택해 주세요. - </h2>");
    }
    function showList() {
        if ($("#memberStatus").val() == '') {
            $("#memberConfirmBtn").show();
            $("#memberRefuseBtn").show();
        } else {
            $("#memberConfirmBtn").hide();
            $("#memberRefuseBtn").hide();
        }
        $("#DetailMemberInfo").show();
        $("#DetailShow").show();
        $(".selectMember").remove();
    }

    //페이지 이동 스크립트
    function fn_page(pageNo) {
        showLoader(true)
        //vo에 담긴 값이 입력된 값과 다를 경우 강제로 vo에 담긴 값을 form에 넣어주기
        if (userId != $("#searchUserId")) {
            frm.userId.value = userId;
        }
        if (userRegion != $("#searchUserRegion")) {
            frm.userRegionMaster.value = userRegion;
        }
        if (userSex != $("#searchUserSex")) {
            frm.userSex.value = userSex;
        }
        if (userType != $("#searchUserType")) {
            frm.userType.value = userType;
        }
        showLoader(true);
        frm.pageIndex.value = pageNo;
        document.frm.action = "<c:url value='/member.do'/>";
        document.frm.submit();
    }

    //조회
    function fn_search() {
        showLoader(true);
        frm.pageIndex.value = 1;
        document.frm.action = "<c:url value='/member.do'/>";
        document.frm.submit();
    }

    //초기화
    function fn_reset() {
        showLoader(true);
        $("#searchUserId").val("");
        $("#searchUserRegion").val("");
        $("#searchUserAge").val("");
        $("#searchUserSex").val("");
        $("#searchUserType").val("");

        frm.pageIndex.value = 1;
        document.frm.action = "<c:url value='/member.do'/>";
        document.frm.submit();
    }

</script>
<body>
<jsp:include page="/menu"/>
<div class="wd100rate h100rate">
    <table class="searchTable">
        <form:form id="frm" name="frm" method="post">
        <input type="hidden" id="pageIndex" name="pageIndex" value="${joinVO.pageIndex}">
        <tr>
            <th>아이디/이름</th>
            <td class="wd100"><input type="text" id="searchUserId" name="userId" value="${joinVO.userId}"></td>
            <th>지역</th>
            <td class="wd100">
                <select id="searchUserRegion" name="userRegionMaster" class="wd90">
                    <option value="">전체</option>
                    <c:forEach var="item" items="${CG_RGN}">
                        <option value="${item.codeId}">${item.codeIdName}</option>
                    </c:forEach>
                </select>
            </td>
            <th>성별</th>
            <td class="wd100">
                <select id="searchUserSex" name="userSex" class="wd90">
                    <option value="">전체</option>
                    <c:forEach var="item" items="${CG_SEX}">
                        <option value="${item.codeId}">${item.codeIdName}</option>
                    </c:forEach>
                </select>
            </td>
            <th>구분</th>
            <td>
                <select id="searchUserType" name="userType" class="wd90">
                    <option value="">전체</option>
                    <c:forEach var="item" items="${CG_UST}">
                        <option value="${item.codeId}">${item.codeIdName}</option>
                    </c:forEach>
                </select>
            </td>
            <td><a class="button resetBtn bgc_grayC mt10 fr" onclick="fn_reset();"><i class="bx bx-redo"></i>초기화</a>
                <a class="button bgcSkyBlue mt10 fr searchBtn" onclick="fn_search();"><i class="bx bx-search"></i>조회</a>
            </td>
        </tr>
    </table>
    <div class="wd100rate h100rate bgc_w">
        <div class="wd70rate h100rate fl brDeepBlue">
            <table class="viewTable font_size15">
                <caption style="text-align: left; padding: 0 0 10px 0; margin: -10px auto;">
                    <img src="resources/image/member/memberStatus.svg" class="memberStatusImg backgroundImgGreen"> : 승인
                    <img src="resources/image/member/memberStatus.svg" class="memberStatusImg backgroundImgRed"> : 거절
                    <img src="resources/image/member/memberStatus.svg" class="memberStatusImg backgroundImgStay"> : 대기
                </caption>
                <thead>
                <colgroup>
                    <col width="5%"/>
                    <col width="7%"/>
                    <col width="12%"/>
                    <col width="8%"/>
                    <col width="10%"/>
                    <col width="15%"/>
                    <col width="5%"/>
                    <col width="5%"/>
                    <col width="10%"/>
                    <col width="10%"/>
                </colgroup>
                </thead>
                <tr>
                    <th class="wd5rate">NO</th>
                    <th>구분</th>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>지역</th>
                    <th>전화번호</th>
                    <th>나이</th>
                    <th>성별</th>
                    <th class="wd20rate">가입 등록 일시</th>
                    <th>당일 출석 여부</th>
                </tr>
                <c:forEach var="resultList" items="${resultList}" varStatus="status">
                    <tr class="cursor_pointer itemRow h40">
                        <td>${paginationInfo.totalRecordCount - ((joinVO.pageIndex-1) * 10) - status.index}</td>
                        <c:choose>
                            <c:when test="${resultList.signInStatus eq 'Y'}">
                                <td class="memberStatusImgTd"><img src="resources/image/member/memberStatus.svg" class="memberStatusImg backgroundImgGreen">${resultList.userTypeName}</td>
                            </c:when>
                            <c:when test="${resultList.signInStatus eq 'N'}">
                                <td class="memberStatusImgTd"><img src="resources/image/member/memberStatus.svg" class="memberStatusImg backgroundImgRed">${resultList.userTypeName}</td>
                            </c:when>
                            <c:otherwise>
                                <td class="memberStatusImgTd"><img src="resources/image/member/memberStatus.svg" class="memberStatusImg backgroundImgStay">${resultList.userTypeName}</td>
                            </c:otherwise>
                        </c:choose>
                        <td>${resultList.userId}</td>
                        <td>${resultList.userName}</td>
                        <td>${resultList.userRegionName}</td>
                        <td>${resultList.userPhone}</td>
                        <td>${resultList.userAge}</td>
                        <td>${resultList.userSexName}</td>
                        <td><fmt:formatDate value="${resultList.regDt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>
                            <c:forEach var="registerGbn" items="${registerList[status.index]}" varStatus="registerGbn">
                                <c:set var="timeStatus"
                                       value="status00${registerGbn.index+1}"/> <!--status00 이후 값 동적 세팅-->
                                <c:choose>
                                    <c:when test="${registerList[status.index][timeStatus] eq 'X'}">
                                        <i class="bx bx-x-circle xCircleBx"></i>
                                    </c:when>
                                    <c:when test="${registerList[status.index][timeStatus] eq 'O'}">
                                        <i class="bx bx-check-circle checkBx"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bx bx-minus-circle"></i>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </td>
                        <td style="display: none;">${resultList.signInStatus}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty resultList}">
                    <tr class="noneHover">
                        <td align="center" colspan="10" rowspan="10">- 해당 데이터가 존재하지 않습니다. -</td>
                    </tr>
                </c:if>
                <c:if test="${!empty resultList && resultList.size() ne 10}">
                    <tr style="background-color: rgba(255,255,255,0)" class="noneHover">
                        <td align="center" colspan="10" rowspan="${10-resultList.size()}"></td>
                    </tr>
                </c:if>
            </table>
            <div id="pagination" class="pagingBox align_c">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page"/>
            </div>
        </div>
        </form:form>
        <div class="h100rate fr wd28rate">
            <div id="DetailShow"><h2 class="mt50"><i class="bx bx-detail" id="detail"></i><strong> 상세 </strong></h2></div>
            <div id="DetailMemberInfo">
                <form:form id="memberInfo" method="post">
                    <table class="listTable wd95rate">
                        <tr class="h57">
                            <td class="align_l wd130"><label>아이디</label></td>
                            <td><input type="text" readonly class="wd210" name="userId" id="userId" disabled></td>
                        </tr>
                        <tr class="h57">
                            <td class="align_l"><label>비밀번호</label></td>
                            <td><input type="password" class="wd210" name="userPassword" id="userPassword" maxlength="20">
                            </td>
                        </tr>
                        <tr class="h57">
                            <td class="align_l"><label>비밀번호 확인</label></td>
                            <td><input type="password" class="wd210" name="userPassword" id="userPasswordConfirm"
                                       maxlength="20"></td>
                        </tr>
                        <tr class="h57">
                            <td class="align_l"><label>이름</label></td>
                            <td><input type="text" readonly class="wd210" id="userName" disabled></td>
                        </tr>
                        <tr class="h57">
                            <td class="align_l"><label>전화번호</label></td>
                            <td><input type="text" readonly class="wd210" id="userPhone" disabled></td>
                        </tr>
                        <tr class="h57">
                            <td class="align_l"><label>나이</label></td>
                            <td><input type="text" readonly class="wd210" id="userAge" disabled></td>
                        </tr>
                        <tr class="h57">
                            <td class="align_l"><label>지역</label></td>
                            <td><input type="text" readonly class="wd210" id="userRegion" disabled></td>
                        </tr>
                        <tr class="h57">
                            <td class="align_l"><label>성별</label></td>
                            <td><input type="text" readonly class="wd210" id="userSex" disabled></td>
                        </tr>
                        <tr class="h57">
                            <td class="align_l"><label>구분</label></td>
                            <td><input type="text" readonly class="wd210" id="userType" disabled></td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                            <td><input type="text" readonly class="wd210" id="memberStatus" disabled></td>
                            </td>
                        </tr>
                        <tr class="h80">
                            <td colspan="4" class="align_c">
                                <a class="button bgcLightGreen" id="memberConfirmBtn"><i class="bx bxs-user-plus"></i><strong>승인</strong></a>
                                <a class="button bgcDeepRed" id="memberRefuseBtn"><i class="bx bxs-user-minus"></i>거절</a>
                                <a class="button bgcDeepBlue" id="memberSaveBtn"><i
                                        class="bx bxs-save"></i><strong>저장</strong></a>
                                <a class="button bgcDeepRed" id="memberDeleteBtn"><i class="bx bx-minus-circle"></i>탈퇴</a>
                            </td>
                        </tr>
                    </table>
                </form:form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
