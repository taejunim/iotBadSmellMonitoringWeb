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
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @ Class Name   : StatisticSmellTableController.java
 * @ Modification : Statistic CONTROLLER (통계)
 * @
 * @ 최초 생성일  최초 생성자
 * @ ---------    ---------
 * @ 2023.11.20     김우성
 * @
 * @ 수정일        수정자
 * @ ---------    ---------
 * @
 **/
@Controller
public class StatisticSmellTableController {

    @Autowired
    private MainService      mainService;       //메인화면 관련 SERVICE.
    @Autowired
    private StatisticService statisticService;       //통계 관련 SERVICE.

    @RequestMapping(value = "/statisticSmellTable")
    public String StatisticSmellTable(@ModelAttribute("statisticTableVO") StatisticTableVO statisticTableVO,HttpSession session, ModelMap model) throws Exception {
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
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date now = new Date();

            String searchEnd = dateFormat.format(now);
            statisticTableVO.setSearchStart(searchEnd.substring(0, searchEnd.length() - 2) + "01");
            statisticTableVO.setSearchEnd(searchEnd);
        }
        model.addAttribute("userRegionDetail",statisticTableVO.getUserRegionDetail());
        /**취기 통계 전체 조회 START*/
        model.addAttribute("resultList",statisticService.statisticSmellTableTotal(statisticTableVO));
        model.addAttribute("resultListDetail", statisticService.statisticSmellTableDetail(statisticTableVO));
        /**취기 통계 전체 조회 END*/
        /**취기 마을별 통계  START*/
        model.addAttribute("resultListByRegion",statisticService.statisticSmellTableTotalByRegion(statisticTableVO));
        model.addAttribute("resultListByRegionDetail", statisticService.statisticSmellTableDetailByRegion(statisticTableVO));
        model.addAttribute("userRegion",statisticService.userRegionDetailCode(statisticTableVO));
        /**취기 마을별 통계  END*/
        return "statisticSmellTable";
    }
}
