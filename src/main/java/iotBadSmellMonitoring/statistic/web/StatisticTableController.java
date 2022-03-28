package iotBadSmellMonitoring.statistic.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import iotBadSmellMonitoring.statistic.service.StatisticService;
import iotBadSmellMonitoring.statistic.service.StatisticTableVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @ Class Name   : StatisticTableController.java
 * @ Modification : Statistic CONTROLLER (통계)
 * @
 * @ 최초 생성일  최초 생성자
 * @ ---------    ---------
 * @ 2021.06.08.    조유영
 * @
 * @ 수정일        수정자
 * @ ---------    ---------
 * @
 **/
@Controller
public class StatisticTableController {

    @Autowired
    private MainService      mainService;       //메인화면 관련 SERVICE.
    @Autowired
    private StatisticService statisticService;       //통계 관련 SERVICE.

    //통계
    @RequestMapping("/statisticTable")
    public String statistic(@ModelAttribute("statisticTableVO") StatisticTableVO statisticTableVO, ModelMap model, HttpSession session) throws Exception {

        MainVO mainVO = new MainVO();
        /*냄새 강도, 냄새접수 시간대 SETTING START*/
        // 처음 한번만 값을 가져와서 세션에 저장
        //냄새 강도
        if(session.getAttribute("CG_SMT") == null){
            mainVO.setCodeGroup("SMT");
            session.setAttribute("CG_SMT",mainService.codeListSelect(mainVO));
            model.addAttribute("CG_SMT",session.getAttribute("CG_SMT"));
        }
        // 세션에 값을 저장했을 경우 세션값을  model에 넘겨줌
        else{
            model.addAttribute("CG_SMT",session.getAttribute("CG_SMT"));
        }
        //냄새접수 시간대
        if(session.getAttribute("CG_REN") == null){
            mainVO.setCodeGroup("REN");
            session.setAttribute("CG_REN",mainService.codeListSelect(mainVO));
            model.addAttribute("CG_REN",session.getAttribute("CG_REN"));
        }
        // 세션에 값을 저장했을 경우 세션값을  model에 넘겨줌
        else{
            model.addAttribute("CG_REN",session.getAttribute("CG_REN"));
        }
        //지역
        if(session.getAttribute("CG_REM") == null){
            mainVO.setCodeGroup("REM");
            session.setAttribute("CG_REM",mainService.codeListSelect(mainVO));
            model.addAttribute("CG_REM",session.getAttribute("CG_REM"));
        }
        // 세션에 값을 저장했을 경우 세션값을  model에 넘겨줌
        else{
            model.addAttribute("CG_REM",session.getAttribute("CG_REM"));
        }
        //지역 상세
        if(session.getAttribute("CG_RGD") == null){
            mainVO.setCodeGroup("RGD");
            session.setAttribute("CG_RGD",mainService.codeListSelect(mainVO));
            model.addAttribute("CG_RGD",session.getAttribute("CG_RGD"));
        }
        // 세션에 값을 저장했을 경우 세션값을  model에 넘겨줌
        else{
            model.addAttribute("CG_RGD",session.getAttribute("CG_RGD"));
        }

        //날짜 파라미터 없을경우 현재 월로 검색
        if(statisticTableVO.getSearchStart() == null || statisticTableVO.getSearchEnd() == null) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM");
            Date now = new Date();

            String searchMonth = dateFormat.format(now);
            statisticTableVO.setSearchStart(searchMonth);
            statisticTableVO.setSearchEnd(searchMonth);
        }

        //시간대를 동적으로 사용하기 위한 부분
        List<EgovMap> timeList = (List<EgovMap>) model.get("CG_REN");
        List<EgovMap> resultList = new ArrayList<>();

        //시간대와 지역이 바뀌어도 동적으로 화면에 보내줄 수 있도록
        for(int i = 0; i <= timeList.size(); i ++){
            //처음은 시간대 없이 조회
            if(i != 0) statisticTableVO.setSmellRegisterTime(timeList.get(i - 1).get("codeId").toString());
            resultList.add(statisticService.statisticTableSelect(statisticTableVO));

        }
        model.addAttribute("resultList",resultList);

        return "statisticTable";
    }

    //엑셀 다운로드 - 시간 없이 전체만 구한다.
    @RequestMapping(value = "/statisticTableDataExcelDownload")
    public String staitsticTableDataExcelDownload(StatisticTableVO statisticTableVO, ModelMap modelMap, HttpServletResponse response) throws Exception {

        /* 쿠키를 이용한 로딩 START */
        Cookie cookie = new Cookie("loading", "true");
        cookie.setPath("/");
        response.addCookie(cookie);
        /* 쿠키를 이용한 로딩 END */

        EgovMap result = statisticService.statisticTableSelect(statisticTableVO);

        List<EgovMap> list = (List<EgovMap>) result.get("list");

        Map<String,Object> regionCountMap = new HashMap<>();
        String regionMaster = "";
        int regionMasterCount = 0;

        //자바스크립트 사용을 할수 없어 rowspan을 하기 위한 처리
        for(int i = 0 ;i < list.size() ; i ++){

            if(i == 0) regionMaster = list.get(i).get("userRegionMaster").toString();

            //System.out.println(list.get(i).get("userRegionMaster").equals(regionMaster));

            if(list.get(i).get("userRegionMaster").equals(regionMaster)){
                regionMasterCount ++;
            } else {
                regionCountMap.put(regionMaster,regionMasterCount);
                regionMaster = list.get(i).get("userRegionMaster").toString();
                regionMasterCount = 1;
            }
        }

        modelMap.addAttribute("result",statisticService.statisticTableSelect(statisticTableVO));
        modelMap.addAttribute("regionCountMap",regionCountMap);
        return "statisticTableDataExcelDownload";
    }
}
