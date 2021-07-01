package iotBadSmellMonitoring.join.web;

import iotBadSmellMonitoring.join.service.JoinService;
import iotBadSmellMonitoring.join.service.JoinVO;
import iotBadSmellMonitoring.main.service.MainService;
import iotBadSmellMonitoring.main.service.MainVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

/**
 * @ Class Name   : JoinController.java
 * @ Modification : 회원가입 / 아이디 찾기 관련 CONTROLLER
 * @
 * @ 최초 생성일     최초 생성자
 * @ ---------    ---------
 * @ 2021.06.03.    고재훈
 * @
 * @ 수정일           수정자
 * @ ---------    ---------
 * @
 **/
@Controller
public class JoinController {

    @Autowired
    private MainService mainService;

    @Autowired
    private JoinService joinService;

    //회원가입 화면
    @RequestMapping("/join")
    public String join(HttpSession session, ModelMap model) throws Exception{

        /*성별, 구분 SETTING START*/
            // 처음 한번만 값을 가져와서 세션에 저장
            if(session.getAttribute("CG_UST") == null){

                MainVO mainVO = new MainVO();

                mainVO.setCodeGroup("SEX");
                session.setAttribute("CG_SEX",mainService.codeListSelect(mainVO));
                model.addAttribute("CG_SEX",session.getAttribute("CG_SEX"));

                mainVO.setCodeGroup("UST");
                session.setAttribute("CG_UST",mainService.codeListSelect(mainVO));
                model.addAttribute("CG_UST",session.getAttribute("CG_UST"));

                mainVO.setCodeGroup("RGN");
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

        return "join";
    }


    //회원 가입 요청
    @RequestMapping(value = "/join/userJoinInsert", method = RequestMethod.POST)
    public @ResponseBody String userJoinInsert(@ModelAttribute JoinVO joinVO) throws Exception {
        System.out.println("JoinVO  --->  " + joinVO);
        String result = "";

        //예외처리
        try {
            joinService.userJoinInsert(joinVO);
            result = "success";
        }catch (Exception e) {
            result = "fail";
        }
        return result;
    }

    //아이디 중복 체크
    @RequestMapping(value = "/join/userFindIdSelect", method = RequestMethod.POST)
    public @ResponseBody String userFindIdSelect(@RequestParam String userId) throws Exception {

        String result = "";
        result = joinService.userFindIdSelect(userId);

        return result;
    }

}
