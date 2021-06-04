package iotBadSmellMonitoring.member.web;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
public class MemberController {

    @Autowired
    private MainService mainService;

    //회원관리
    @RequestMapping("/member")
    public String memberManagement(HttpSession session, ModelMap model) throws Exception{

        /*성별, 구분 SETTING START*/
        // 처음 한번만 값을 가져와서 세션에 저장
        if(session.getAttribute("CG_UST") == null){
            MainVO mainVO = new MainVO();

            mainVO.setCodeGroup("UST");
            session.setAttribute("CG_UST",mainService.codeListSelect(mainVO));
            model.addAttribute("CG_UST",session.getAttribute("CG_UST"));

            mainVO.setCodeGroup("SEX");
            session.setAttribute("CG_SEX",mainService.codeListSelect(mainVO));
            model.addAttribute("CG_SEX",session.getAttribute("CG_SEX"));
        }
        // 세션에 값을 저장했을 경우 세션값을  model에 넘겨줌
        else{
            model.addAttribute("CG_UST",session.getAttribute("CG_UST"));
            model.addAttribute("CG_SEX",session.getAttribute("CG_SEX"));
        }
        /*성별, 구분 SETTING END*/

        /*페이징 SETTING START*/
        PaginationInfo paginationInfo = new PaginationInfo();

        paginationInfo.setCurrentPageNo(1);
        paginationInfo.setRecordCountPerPage(10);
        paginationInfo.setPageSize(10);

        paginationInfo.setTotalRecordCount(100);

        model.addAttribute("paginationInfo", paginationInfo);
        /*페이징 SETTING END*/

        return "member";
    }
}
