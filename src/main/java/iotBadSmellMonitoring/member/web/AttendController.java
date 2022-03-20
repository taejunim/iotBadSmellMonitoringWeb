package iotBadSmellMonitoring.member.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import iotBadSmellMonitoring.member.service.AttendService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * @ Class Name   : AttendController.java
 * @ Notification : USER ATTEND CONTROLLER
 * @
 * @ 최초 생성일      최초 생성자
 * @ ---------    ---------
 * @ 2021.03.18.    고재훈
 * @
 * @   수정일         수정자
 * @ ---------    ---------
 * @
 **/
@Controller
public class AttendController {

    @Autowired
    private AttendService attendService;

    @Autowired
    private MainService mainService;

    //회원 출석 상태 화면
    @RequestMapping("/attend")
    public String attendView(@ModelAttribute("joinVO") JoinVO joinVO, MainVO mainVO, ModelMap model, HttpSession session) throws Exception {

        String serachYear  = "";                                                                                        // 검색 연.
        String serachMonth = "";                                                                                        // 검색 월.
        int    lastDay     = 0;                                                                                         // 검색 연 월의 마지막 일을 알기 위한 변수.

        joinVO.setCommonGbn1("view");                                                                                   //xml에서 view와 excel을 구분하기 위한 SET.

        /*성별, 구분 SETTING START*/
        // 처음 한번만 값을 가져와서 세션에 저장
        if (session.getAttribute("CG_REM") == null) {

            mainVO.setCodeGroup("REM");
            session.setAttribute("CG_REM", mainService.codeListSelect(mainVO));
            model.addAttribute("CG_REM", session.getAttribute("CG_REM"));
        }
        // 세션에 값을 저장했을 경우 세션값을  model에 넘겨줌
        else {
            model.addAttribute("CG_REM", session.getAttribute("CG_REM"));
        }
        /*성별, 구분 SETTING END*/

        if(joinVO.getSearchYear() == null && joinVO.getSearchMonth() == null){                                          // 첫 페이지 load 시 VO에 값이 없으므로 SET을 위한.

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy");
            Date             now        = new Date();
            serachYear                  = dateFormat.format(now);

            dateFormat                  = new SimpleDateFormat("MM");
            now                         = new Date();
            serachMonth                 = dateFormat.format(now);

            joinVO.setSearchYear(serachYear);
            joinVO.setSearchMonth(serachMonth);

        }else{                                                                                                          // VO에 값이 있을 떄.

            serachYear                  = joinVO.getSearchYear();
            serachMonth                 = joinVO.getSearchMonth();
        }

        Calendar cal                    = Calendar.getInstance();
        cal.set(Integer.parseInt(serachYear), Integer.parseInt(serachMonth)-1, 1);                          // 월은 -1해줘야 해당월로 인식.

        lastDay                         = cal.getActualMaximum(Calendar.DAY_OF_MONTH);                                  // 검색 연 월의 일 GET.
        List<EgovMap> dateList          = new ArrayList<>();                                                            // HEARDER 일수 SETTING을 위한 LIST MAP 변수.
        List<EgovMap> resultList        = new ArrayList<>();                                                            // 사용자 체크 리스트 SETTING을 위한 LIST MAP 변수.

        for(int i =0; i < lastDay; i ++){                                                                               // HEARDER 일수 SETTING을 위한 반복문.

            EgovMap egovMap             = new EgovMap();
            egovMap.put("DAY",i+1);
            dateList.add(egovMap);
        }

        /*페이징 SETTING START*/
        PaginationInfo paginationInfo = new PaginationInfo();

        paginationInfo.setCurrentPageNo(joinVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(joinVO.getPageUnit());
        paginationInfo.setPageSize(joinVO.getPageSize());

        joinVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        joinVO.setLastIndex(paginationInfo.getLastRecordIndex());
        joinVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        if (joinVO.getPageIndex() != 1)
            joinVO.setPageRowIndex(joinVO.getPageIndex() * 10 - 10);

        paginationInfo.setTotalRecordCount(attendService.attendUserTotalCnt(joinVO));                                   //출석 회원 총 카운트 CALL.

        /*
         * 1. 회원 목록을 가져온다.(attendUserList)
         * 2. 회원 별, 검색 연 / 월에 선택된 일수별 하루 3번 체크 목록을 가져온다.(attendUserCheckList)
         * 3. attendUserCheckList를 EgovMap에 담아서 attendUserList add 시킨다.
         * 4. 위 결과 resultList를 model에 담아서 View에서 뿌려준다.
         */
        List<EgovMap> attendUserList   = attendService.attendUserList(joinVO);                                          // 출석 회원 리스트 목록 CALL.

        joinVO.setRegDt(serachYear+"-"+serachMonth+"-"+lastDay);

        for(int i = 0; i < attendUserList.size(); i++){

            joinVO.setUserId(attendUserList.get(i).getValue(0).toString());

            List<EgovMap> attendUserCheckList   = attendService.attendUserCheckList(joinVO);                            // 출석 여부 확인 리스트 목록 CALL.
            EgovMap       attendCheckMap        = new EgovMap();

            attendCheckMap.put("USER_ID",attendUserList.get(i).getValue(0));
            attendCheckMap.put("USER_NAME",attendUserList.get(i).getValue(1));
            attendCheckMap.put("USER_REGION_MASTER",attendUserList.get(i).getValue(2));
            attendCheckMap.put("USER_REGION_DETAIL",attendUserList.get(i).getValue(3));
            attendCheckMap.put("USER_REGION_MASTER_NAME",attendUserList.get(i).getValue(4));
            attendCheckMap.put("USER_REGION_DETAIL_NAME",attendUserList.get(i).getValue(5));

            int regDayCount = 0;                                                                                        // 1일 3회 24일 이상 출석을 위한 변수.

            for(int j = 0; j < attendUserCheckList.size(); j++) {

                String result = String.valueOf(attendUserCheckList.get(j).getValue(2));
                attendCheckMap.put("DAY_" + j, result);

                if(result.equals("O"))
                    regDayCount ++;
            }

            attendCheckMap.put("USER_REG_COUNT",regDayCount+"/"+lastDay);

            if(regDayCount<23)                                                                                          // 24일 이상일 경우 수당 지금 여부 O.
                attendCheckMap.put("USER_DAY_CHECK","X");
            else
                attendCheckMap.put("USER_DAY_CHECK","O");

            resultList.add(attendCheckMap);
        }

        model.addAttribute("dateList", dateList);
        model.addAttribute("dateCount",dateList.size());
        model.addAttribute("resultList", resultList);
        model.addAttribute("paginationInfo", paginationInfo);
        /*페이징 SETTING END*/

        return "attend";
    }

    //지역 선택시 해당지역상세 표출
    @RequestMapping(value = "/attend/userRegionSelect", method = RequestMethod.POST)
    public @ResponseBody
    List<EgovMap> userRegionSelect(MainVO mainVO) throws Exception {

        List<EgovMap> list = mainService.codeListSelect(mainVO);

        return list;
    }

    public static String exceclYear  = "";                                                                              //EXCEL 제목의 YEAR을  위한 변수.
    public static String exceclMonth = "";                                                                              //EXCEL 제목의 MONTH를 위한 변수.

    //엑셀 다운로드
    @RequestMapping(value = "/attendDataExcelDownload")
    public String attendDataExcelDownload(@ModelAttribute("joinVO") JoinVO joinVO,ModelMap model) throws Exception {

        String serachYear  = "";                                                                                        // 검색 연.
        String serachMonth = "";                                                                                        // 검색 월.
        int    lastDay     = 0;                                                                                         // 검색 연 월의 마지막 일을 알기 위한 변수.
        serachYear         = joinVO.getSearchYear();
        serachMonth        = joinVO.getSearchMonth();
        exceclYear         = serachYear;                                                                                //EXCEL 제목의 YEAR  SET.
        exceclMonth        = serachMonth;                                                                               //EXCEL 제목의 MONTH SET.

        Calendar cal       = Calendar.getInstance();
        cal.set(Integer.parseInt(serachYear), Integer.parseInt(serachMonth)-1, 1);                          // 월은 -1해줘야 해당월로 인식.

        lastDay                         = cal.getActualMaximum(Calendar.DAY_OF_MONTH);                                  // 검색 연 월의 일 GET.
        List<EgovMap> dateList          = new ArrayList<>();                                                            // HEARDER 일수 SETTING을 위한 LIST MAP 변수.
        List<EgovMap> resultList        = new ArrayList<>();                                                            // 사용자 체크 리스트 SETTING을 위한 LIST MAP 변수.

        for(int i =0; i < lastDay; i ++){                                                                               // HEARDER 일수 SETTING을 위한 반복문.

            EgovMap egovMap             = new EgovMap();
            egovMap.put("DAY",i+1);
            dateList.add(egovMap);
        }

        /*
         * 1. 회원 목록을 가져온다.(attendUserList)
         * 2. 회원 별, 검색 연 / 월에 선택된 일수별 하루 3번 체크 목록을 가져온다.(attendUserCheckList)
         * 3. attendUserCheckList를 EgovMap에 담아서 attendUserList add 시킨다.
         * 4. 위 결과 resultList를 model에 담아서 View에서 뿌려준다.
         */

        joinVO.setCommonGbn1("excel");                                                                                  //xml에서 view와 excel을 구분하기 위한 SET.

        List<EgovMap> attendUserList   = attendService.attendUserList(joinVO);                                          // 출석 회원 리스트 목록 CALL.

        joinVO.setRegDt(serachYear+"-"+serachMonth+"-"+lastDay);

        for(int i = 0; i < attendUserList.size(); i++){

            joinVO.setUserId(attendUserList.get(i).getValue(0).toString());

            List<EgovMap> attendUserCheckList   = attendService.attendUserCheckList(joinVO);                            // 출석 여부 확인 리스트 목록 CALL.
            EgovMap       attendCheckMap        = new EgovMap();

            attendCheckMap.put("USER_ID",attendUserList.get(i).getValue(0));
            attendCheckMap.put("USER_NAME",attendUserList.get(i).getValue(1));
            attendCheckMap.put("USER_REGION_MASTER",attendUserList.get(i).getValue(2));
            attendCheckMap.put("USER_REGION_DETAIL",attendUserList.get(i).getValue(3));
            attendCheckMap.put("USER_REGION_MASTER_NAME",attendUserList.get(i).getValue(4));
            attendCheckMap.put("USER_REGION_DETAIL_NAME",attendUserList.get(i).getValue(5));

            int regDayCount = 0;                                                                                        // 1일 3회 24일 이상 출석을 위한 변수.

            for(int j = 0; j < attendUserCheckList.size(); j++) {

                String result = String.valueOf(attendUserCheckList.get(j).getValue(2));
                attendCheckMap.put("DAY_" + j, result);

                if(result.equals("O"))
                    regDayCount ++;
            }

            attendCheckMap.put("USER_REG_COUNT",regDayCount+"/"+lastDay);

            if(regDayCount<23)                                                                                          // 24일 이상일 경우 수당 지금 여부 O.
                attendCheckMap.put("USER_DAY_CHECK","X");
            else
                attendCheckMap.put("USER_DAY_CHECK","O");

            resultList.add(attendCheckMap);
        }

        model.addAttribute("dateList", dateList);
        model.addAttribute("dateCount",dateList.size());
        model.addAttribute("resultList", resultList);

        return "attendDataExcelDownload";
    }

}
