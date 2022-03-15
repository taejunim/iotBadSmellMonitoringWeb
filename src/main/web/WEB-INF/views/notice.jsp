<%--
  Created by IntelliJ IDEA.
  User: 김재연
  Date: 2022/03/11
  Time: 9:42 오전
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/views/common/resources_common.jsp" %>
<script type="text/javascript">
    var noticeTitle = '${noticeVO.noticeTitle}';     //검색조건_제목
    var startDate   = '${noticeVO.startDate}';       //검색조건_등록일자 시작
    var endDate     = '${noticeVO.endDate}';         //검색조건_등록일자 끝
    var update      = false;                         //update or insert

    $(document).ready(function () {
        setButton("notice");            //선택된 화면의 메뉴색 변경 CALL
        setDatePicker();                //달력 SETTING CALL.

        /* 검색 화면 검색어 세팅 START*/
        //시작날짜
        if (startDate != "" && startDate != null)
            $("#searchStartDt").val(startDate).prop("selected", true);

        //종료날짜
        if (endDate != "" && endDate != null)
            $("#searchEndDt").val(endDate).prop("selected", true);
        /* 검색 화면 검색어 세팅 END*/

        //검색 버튼 클릭 이벤트
        $(".searchBtn").click(function () {
            fn_search();
        });

        //검색조건 초기화 버튼 클릭 이벤트
        $(".resetBtn").click(function () {
            showLoader(true);
            $(location).attr('href', '/notice.do');
        });
        /* 검색 화면 검색어 세팅 END*/

        /*달력 SETTING START*/
        function setDatePicker() {

            //datepicker 초기화 START
            $('#datePicker').datepicker();

            $('#searchStartDt').datepicker();
            $('#searchStartDt').datepicker("option", "maxDate", $("#searchEndDt").val());
            $('#searchStartDt').datepicker("option", "onClose", function (selectedDate) {
                $("#searchEndDt").datepicker("option", "minDate", selectedDate);
            });

            $('#searchEndDt').datepicker();
            $('#searchEndDt').datepicker("option", "minDate", $("#searchStartDt").val());
            $('#searchEndDt').datepicker("option", "onClose", function (selectedDate) {
                $("#searchStartDt").datepicker("option", "maxDate", selectedDate);
            });
            //datepicker 초기화 END
        }
        /*달력 SETTING END*/

        /* 테이블 row 클릭 이벤트 START*/
        $(".itemRow").click(function () {

            $(this).css('background-color', 'rgb(217,239,255)');                        //선택된 로우 색상 변경
            $(".itemRow").not($(this)).css('background-color', 'rgba(255,255,255,0)');  //선택되지 않은 로우 색상

            /*오른쪽 table에 값 담아주기 START*/
            var getItems = $(this).find("td");  //viewTable의 row

            $("#getNoticeTitle").val(getItems.eq(1).text());    //제목
            $("#noticeContents").val(getItems.eq(2).text());    //내용
            $("#regId").val(getItems.eq(3).text());             //등록자
            $("#regDt").val(getItems.eq(4).text());             //등록일자
            $("#modId").val(getItems.eq(5).text());             //수정자
            $("#modDt").val(getItems.eq(6).text());             //수정일자
            $("#noticeId").val(getItems.eq(7).text());          //notice_Id
            /*오른쪽 table에 값 담아주기 END*/

        });
        /* 테이블 row 클릭 이벤트 END*/

        /* 저장 버튼 클릭 이벤트 START*/
        $("#memberSaveBtn").click(function () {

            //제목 공백 확인
            if ($("#getNoticeTitle").val() === undefined || $("#getNoticeTitle").val().trim() === "") {
                alert("제목을 입력하여 주십시오.");
            }
            //내용 공백 확인
            else if ($("#noticeContents").val() === undefined || $("#noticeContents").val().trim() === "") {
                alert("내용을 입력하여 주십시오.");
            } else {
                //공지사항 등록
                if ($("#noticeId").val() === undefined || $("#noticeId").val().trim() === "") {
                    update = false;
                    var con_test = confirm("공지사항을 등록하시겠습니까?");
                    fn_save();
                }
                //공지사항 수정
                else {
                    update = true;
                    var con_test = confirm("공지사항을 수정하시겠습니까?");
                    fn_save();
                }
            }

            //저장버튼 클릭 함수
            function fn_save() {
                if (con_test === true) {
                    showLoader(true);
                    $.ajax({
                        url: "/noticeInsertUpdate/",
                        type: "POST",
                        data: {
                            noticeId: $("#noticeId").val(),
                            noticeTitle: $("#getNoticeTitle").val(),
                            noticeContents: $("#noticeContents").val()
                        },
                        dataType: "text",
                        success: function (data) {
                            if (update === false) {
                                alert("공지사항을 등록하였습니다.");
                            } else {
                                alert("공지사항을 수정하였습니다.");
                            }
                            fn_reset();
                        },
                        error: function (err) {
                            console.log(err);
                            alert("공지사항 변경을 실패하였습니다.");
                        }
                    }).done(function () {
                        showLoader(false);
                    });
                }
            }
        })
        /* 저장 버튼 클릭 이벤트 END*/

        /* 탈퇴 버튼 클릭 이벤트 START*/
        $("#memberDeleteBtn").click(function () {

            var noticeTitle = $("#getNoticeTitle").val().trim();
            var con_test = confirm("공지사항을 삭제하시겠습니까?");

            //공지사항을 선택 했는지 체크
            if (noticeTitle === undefined || noticeTitle === "") {
                alert("삭제할 공지사항을 선택해 주세요.");
                return false;
            }

            if (con_test == true) {
                showLoader(true);
                $.ajax({
                    url: "/noticeDelete/",
                    type: "POST",
                    data: {noticeId: $("#noticeId").val()},
                    dataType: "text",
                    success: function (data) {
                        alert("공지사항을 삭제하였습니다.");
                        fn_page($("#pageIndex").val());
                    },
                    error: function (err) {
                        console.log(err);
                        alert("공지사항 삭제를 실패하였습니다.");
                    }
                })
            }
        })
        /* 탈퇴 버튼 클릭 이벤트 END*/
    });

    //페이지 이동 스크립트
    function fn_page(pageNo) {
        //vo에 담긴 값이 입력된 값과 다를 경우 강제로 vo에 담긴 값을 form에 넣어주기
        if (noticeTitle != $("#searchNoticeTitle")) {
            frm.noticeTitle.value = noticeTitle;
        }
        if (startDate != $("#searchStartDt")) {
            frm.startDate.value = startDate;
        }
        if (endDate != $("#searchEndDt")) {
            frm.endDate.value = endDate;
        }
        showLoader(true);
        frm.pageIndex.value = pageNo;
        document.frm.action = "<c:url value='/notice.do'/>";
        document.frm.submit();
    }

    //조회
    function fn_search() {
        showLoader(true);
        frm.pageIndex.value = 1;
        document.frm.action = "<c:url value='/notice.do'/>";
        document.frm.submit();
    }

    //초기화
    function fn_reset() {
        showLoader(true);
        $("#searchNoticeTitle").val("");
        $("#searchStartDt").val("");
        $("#searchEndDt").val("");

        frm.pageIndex.value = 1;
        document.frm.action = "<c:url value='/notice.do'/>";
        document.frm.submit();
    }

</script>
<body>
<jsp:include page="/menu"/>
<div class="wd100rate h100rate scrollView">
    <table class="searchTable">
        <form:form id="frm" name="frm" method="post">
        <input type="hidden" id="pageIndex" name="pageIndex" value="${noticeVO.pageIndex}">
        <tr>
            <th>제목</th>
            <td class="wd110"><input type="text" id="searchNoticeTitle" name="noticeTitle"
                                     value="${noticeVO.noticeTitle}"></td>
            <th class="wd110">등록일자</th>
            <td>
                <input type="date" name="startDate" class="mDateTimeInput" value="${noticeVO.startDate}"
                       id="searchStartDt" readonly="readonly">
                ~
                <input type="date" name="endDate" class="mDateTimeInput" value="${noticeVO.endDate}" id="searchEndDt"
                       readonly="readonly">
            </td>
            <td>
                <a class="button resetBtn bgc_grayC mt10 fr" onclick="fn_reset();"><i class="bx bx-redo"></i>초기화</a>
                <a class="button bgcSkyBlue mt10 fr searchBtn" onclick="fn_search();"><i class="bx bx-search"></i>조회</a>
            </td>
        </tr>
    </table>
    <div class="wd100rate h100rate bgc_w">
        <div class="wd65rate h100rate fl brDeepBlue">
            <table class="viewTable font_size15">
                <thead>
                <colgroup>
                    <col width="5%"/>
                    <col width="25%"/>
                    <col width="8%"/>
                    <col width="10%"/>
                    <col width="8%"/>
                    <col width="10%"/>
                </colgroup>
                </thead>
                <tr>
                    <th class="wd5rate">NO</th>
                    <th>제목</th>
                    <th>등록자</th>
                    <th>등록일자</th>
                    <th>수정자</th>
                    <th>수정일자</th>
                </tr>
                <c:forEach var="resultList" items="${resultList}" varStatus="status">
                    <tr class="cursor_pointer itemRow h40">
                        <td>${paginationInfo.totalRecordCount - ((noticeVO.pageIndex-1) * 10) - status.index}</td>
                        <td>${resultList.noticeTitle}</td>
                        <td style="display:none;">${resultList.noticeContents}</td>
                        <td>${resultList.regId}</td>
                        <td><fmt:formatDate value="${resultList.regDt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>${resultList.modId}</td>
                        <td><fmt:formatDate value="${resultList.modDt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td style="display:none;">${resultList.noticeId}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty resultList}">
                    <tr>
                        <td align="center" colspan="7" rowspan="10">- 해당 데이터가 존재하지 않습니다. -</td>
                    </tr>
                </c:if>
                <c:if test="${!empty resultList && resultList.size() ne 10}">
                    <tr style="background-color: rgba(255,255,255,0)">
                        <td align="center" colspan="7" rowspan="${10-resultList.size()}"></td>
                    </tr>
                </c:if>
            </table>
            <div id="pagination" class="pagingBox align_c">
                <ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_page"/>
            </div>
        </div>
        </form:form>
        <div class="h100rate fr wd32rate">
            <h2 class="mt50"><strong>공지사항</strong></h2>
            <form:form id="memberInfo" method="post">
                <table class="listTable wd95rate">
                    <tr class="h57">
                        <td class="align_l wd130"><label>제목</label></td>
                        <td><input type="text" class="wd350" name="noticeTitle" id="getNoticeTitle" maxlength="50"></td>
                    </tr>
                    <tr class="h57">
                        <td class="align_l"><label>내용</label></td>
                        <td><textarea class="wd350 h200 textarea" name="noticeContents" id="noticeContents"
                                      maxlength="100"></textarea></td>
                    </tr>
                    <tr class="h57">
                        <td class="align_l"><label>등록자</label></td>
                        <td><input type="text" readonly class="wd350" id="regId" disabled></td>
                    </tr>
                    <tr class="h57">
                        <td class="align_l"><label>등록일자</label></td>
                        <td><input type="text" readonly class="wd350" id="regDt" disabled></td>
                    </tr>
                    <tr class="h57">
                        <td class="align_l"><label>수정자</label></td>
                        <td><input type="text" readonly class="wd350" id="modId" disabled></td>
                    </tr>
                    <tr class="h57">
                        <td class="align_l"><label>수정일자</label></td>
                        <td><input type="text" readonly class="wd350" id="modDt" disabled></td>
                        <td><input type="hidden" id="noticeId"></td> <!--noticeId-->
                    </tr>
                    <tr class="h80">
                        <td colspan="2" class="align_c">
                            <a class="button bgcDeepBlue" id="memberSaveBtn"><i
                                    class="bx bxs-save"></i><strong>저장</strong></a>
                            <a class="button bgcDeepRed" id="memberDeleteBtn"><i class="bx bx-minus-circle"></i>삭제</a>
                        </td>
                    </tr>
                </table>
            </form:form>
        </div>
    </div>
</div>
</body>
</html>