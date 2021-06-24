package iotBadSmellMonitoring.statistic.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import iotBadSmellMonitoring.statistic.service.StatisticService;
import iotBadSmellMonitoring.statistic.service.StatisticVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @ Class Name   : Statistic.java
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
public class StatisticController {

    @Autowired
    private MainService      mainService;       //메인화면 관련 SERVICE.
    @Autowired
    private StatisticService statisticService;       //통계 관련 SERVICE.

    //통계
    @RequestMapping("/statistic")
    public String statistic(HttpSession session, ModelMap model) throws Exception {

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
        if(session.getAttribute("CG_RGN") == null){
            mainVO.setCodeGroup("RGN");
            session.setAttribute("CG_RGN",mainService.codeListSelect(mainVO));
            model.addAttribute("CG_RGN",session.getAttribute("CG_RGN"));
        }
        // 세션에 값을 저장했을 경우 세션값을  model에 넘겨줌
        else{
            model.addAttribute("CG_RGN",session.getAttribute("CG_RGN"));
        }

        return "statistic";
    }

    //통계 차트 데이터 조회
    @RequestMapping(value = "/statisticListSelect")
    public @ResponseBody List<EgovMap> statisticListSelect(@ModelAttribute("statisticVO") StatisticVO statisticVO) throws Exception {
        return statisticService.statisticListSelect(statisticVO);
    }
}
