package iotBadSmellMonitoring.history.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import iotBadSmellMonitoring.history.service.HistoryService;
import iotBadSmellMonitoring.history.service.HistoryVO;
import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @ Class Name   : HistoryController.java
 * @ Modification : History MASTER / DETAIL CONTROLLER.
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.11.    메티스
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/

@Controller
public class HistoryController {

    @Autowired
    private MainService mainService;

    @Autowired
    private HistoryService historyService;

    //개별접수이력조회
    @RequestMapping("/history")
    public String history(@ModelAttribute("historyVO") HistoryVO historyVO, ModelMap model) throws Exception {
        System.out.println("HistoryVo ----->" +historyVO);




        MainVO mainVO = new MainVO();

        /*검색조건 SETTING START*/
        mainVO.setCodeGroup("STY");                                                         //취기
        model.addAttribute("CG_STY",mainService.codeListSelect(mainVO));

        mainVO.setCodeGroup("SMT");                                                         //악취강도
        model.addAttribute("CG_SMT",mainService.codeListSelect(mainVO));

        mainVO.setCodeGroup("WET");                                                         //기상 상태
        model.addAttribute("CG_WET",mainService.codeListSelect(mainVO));
        /*검색조건 SETTING END*/

        /*페이징 SETTING START*/
        PaginationInfo paginationInfo = new PaginationInfo();

        paginationInfo.setCurrentPageNo(historyVO.getPageIndex());
        paginationInfo.setRecordCountPerPage(historyVO.getPageUnit());
        paginationInfo.setPageSize(historyVO.getPageSize());

        historyVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
        historyVO.setLastIndex(paginationInfo.getLastRecordIndex());
        historyVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        if(historyVO.getPageIndex() != 1){
            historyVO.setPageRowIndex(historyVO.getPageIndex()*10-10);
        }

        paginationInfo.setTotalRecordCount(historyService.historyListTotalCnt(historyVO));

        model.addAttribute("resultList", historyService.historyListSelect(historyVO));
        model.addAttribute("paginationInfo", paginationInfo);
        /*페이징 SETTING END*/


        return "history";
    }
    //이미지 가져오기
    @RequestMapping(value = "/imageListSelect")
    public @ResponseBody
    List<EgovMap> imageSelect(@ModelAttribute("historyVO") HistoryVO historyVO, ModelMap modelMap) throws Exception {

        modelMap.addAttribute("imageResult", historyService.historyImgListSelect(historyVO));
        return historyService.historyImgListSelect(historyVO);
    }

    //이미지 삭제
    @RequestMapping(value = "/historyImgDelete", method = RequestMethod.GET)
    public @ResponseBody void historyImgDelete(@ModelAttribute HistoryVO historyVO) throws Exception {

        historyService.historyImgDelete(historyVO);
    }
}
