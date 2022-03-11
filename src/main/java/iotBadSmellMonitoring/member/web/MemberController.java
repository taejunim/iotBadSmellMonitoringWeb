package iotBadSmellMonitoring.member.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import iotBadSmellMonitoring.member.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.List;

@Controller
public class MemberController {

    @Autowired
    private MainService mainService;

    @Autowired
    private MemberService memberService;

    //회원관리
    @RequestMapping("/member")
    public String memberManagement(@ModelAttribute("joinVO")JoinVO joinVO, HttpSession session, ModelMap model) throws Exception{

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

            mainVO.setCodeGroup("REM");
            session.setAttribute("CG_RGN",mainService.codeListSelect(mainVO));
            model.addAttribute("CG_RGN",session.getAttribute("CG_RGN"));
        }
        // 세션에 값을 저장했을 경우 세션값을  model에 넘겨줌
        else{
            model.addAttribute("CG_UST",session.getAttribute("CG_UST"));
            model.addAttribute("CG_SEX",session.getAttribute("CG_SEX"));
            model.addAttribute("CG_RGN",session.getAttribute("CG_RGN"));
        }
        /*성별, 구분 SETTING END*/

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

        paginationInfo.setTotalRecordCount(memberService.memberListTotalCnt(joinVO));

        model.addAttribute("resultList", memberService.memberListSelect(joinVO));
        model.addAttribute("paginationInfo", paginationInfo);
        /*페이징 SETTING END*/

        return "member";
    }

    //회원 비밀번호 변경
    @RequestMapping(value = "/memberPasswordUpdate", method = RequestMethod.POST)
    public @ResponseBody void memberPasswordUpdate(@ModelAttribute JoinVO joinVO) throws Exception {

        memberService.memberPasswordUpdate(joinVO);
    }

    //회원 탈퇴
    @RequestMapping(value = "/memberDelete", method = RequestMethod.POST)
    public @ResponseBody void memberDelete(@ModelAttribute JoinVO joinVO) throws Exception {

        memberService.memberDelete(joinVO);
    }
}
