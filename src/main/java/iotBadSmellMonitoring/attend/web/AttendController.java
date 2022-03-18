package iotBadSmellMonitoring.attend.web;

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

import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class AttendController {
    @Autowired
    private MainService mainService;

    @Autowired
    private AttendService attendService;



    //마이페이지 화면
    @RequestMapping("/attend")
    public String attend(@ModelAttribute("joinVO") JoinVO joinVO, ModelMap model) throws Exception {
        Map<String, String> monthDate = new LinkedHashMap<>();
        Map<String, Object> monthDateMap = new LinkedHashMap<>();
        Map<String, Object> attendMap = new LinkedHashMap<>();
        Map<String, String> parameter = new LinkedHashMap<>();

        MainVO mainVO = new MainVO();

        joinVO.setSearchCondition("1");                                                              //페이징여부

        /*검색조건 SETTING START*/
        mainVO.setCodeGroup("REM");
        model.addAttribute("CG_REM",mainService.codeListSelect(mainVO));                //지역

        monthDate = fnMonthDateMap(joinVO, monthDate);                                              // 월 데이터 set
        List<EgovMap> memberList = attendService.memberListSelectTotal(joinVO);                     // 전체 회원 리스트

        for (int i=0; i< memberList.size(); i++) {
            for (String key : monthDate.keySet()) {
                String value = monthDate.get(key);
                parameter.put("regId", (memberList.get(i).get("userId").toString()));
                parameter.put("regDt", key);
                monthDateMap.put( value ,attendService.attendListSelect(parameter));    //회원 데이터, 접수 count
            }
            attendMap.put(memberList.get(i).get("userId").toString(), monthDateMap);                //날짜 데이터, 출석여부
        }

//        for (int i=0; i<monthList.size(); i++) {
//
//            numOfList = attendService.attendListSelect(monthList.get(i));
//            attendMap.put(monthList.get(i), numOfList);
//        }  // 수정해볼꺼


        /*페이징 SETTING START*/
        PaginationInfo paginationInfo = new PaginationInfo();

        paginationInfo.setCurrentPageNo(joinVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(joinVO.getPageUnit());
        paginationInfo.setPageSize(joinVO.getPageSize());

        joinVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        joinVO.setLastIndex(paginationInfo.getLastRecordIndex());
        joinVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        if(joinVO.getPageIndex() != 1){
            joinVO.setPageRowIndex(joinVO.getPageIndex()*10-10);
        }
        /*페이징 SETTING END*/


        paginationInfo.setTotalRecordCount(attendService.memberListTotalCnt(joinVO));
        model.addAttribute("resultList", attendService.memberListSelect(joinVO));
        model.addAttribute("attendMap", attendMap);
        model.addAttribute("monthDate", monthDate);
        model.addAttribute("paginationInfo", paginationInfo);

        return "attend";
    }

    //엑셀 다운로드
    @RequestMapping(value = "/attendDataExcelDownload")
    public String attendDataExcelDownload(JoinVO joinVO,ModelMap modelMap) throws Exception {
        Map<String, String> monthDate = new LinkedHashMap<>();
        List<EgovMap> memberList = attendService.memberListSelectTotal(joinVO);                     //회원 전체 데이터

        Map<String, Object> monthDateMap = new LinkedHashMap<>();
        Map<String, Object> attendMap = new HashMap<>();
        Map<String, String> parameter = new HashMap<>();

        fnMonthDateMap(joinVO, monthDate);                                                          //월 데이터 set
        Set<String> keys = monthDate.keySet();
        Iterator<String> iter = keys.iterator();                                                    //월 데이터

        for (int i=0; i< memberList.size(); i++) {
            while (iter.hasNext()) {
                String key = iter.next();
                parameter.put("regId", (memberList.get(i).get("userId").toString()));
                parameter.put("regDt", key);
                monthDateMap.put(monthDate.get(key) ,attendService.attendListSelect(parameter));    //회원 데이터, 접수 count
            }
            attendMap.put(memberList.get(i).get("userId").toString(), monthDateMap);                //회원 데이터, 출석 여부
        }

        modelMap.addAttribute("resultList", attendService.memberListSelectTotal(joinVO));
        modelMap.addAttribute("attendMap", attendMap);
        modelMap.addAttribute("monthDate", monthDate);

        return "attendDataExcelDownload";
    }

    //지역 선택시 해당지역상세 표출
    @RequestMapping(value = "/attend/userRegionSelect", method = RequestMethod.POST)
    public @ResponseBody
    List<EgovMap> userRegionSelect(MainVO mainVO) throws Exception {

        List<EgovMap> list = mainService.codeListSelect(mainVO);

        return list;
    }


    //월 데이터 set
    private Map<String, String> fnMonthDateMap(JoinVO JoinVO, Map<String, String> monthDate) throws Exception {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance ( );

        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(calendar.MONTH);
        int end = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

        calendar.set(year, month, 1);

        if (JoinVO.getSrtDate() != null && JoinVO.getSrtDate() != "") {  //검색 날짜 있으면 해당 날짜 월 데이터
            year = Integer.parseInt(JoinVO.getSrtDate());
            month = Integer.parseInt(JoinVO.getEndDate()) - 1;

            calendar.set(year, month , 1);
            end = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
        }


        for (int i=1; i<= end; i++) {   // map(2021-00-01, 01) 형태
            monthDate.put(format.format(calendar.getTime()), format.format(calendar.getTime()).substring(8));
            calendar.add(Calendar.DAY_OF_MONTH, 1);
        }

        return monthDate;
    }
}
