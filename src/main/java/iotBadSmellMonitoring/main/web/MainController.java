package iotBadSmellMonitoring.main.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.join.service.JoinService;
import iotBadSmellMonitoring.join.service.JoinVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

/**
 * @ Class Name   : MainController.java
 * @ Modification : MAIN CONTROLLER (로그인 , 메뉴, 메인화면)
 * @
 * @ 최초 생성일  최초 생성자
 * @ ---------    ---------
 * @ 2021.06.01.    조유영
 * @
 * @ 수정일        수정자
 * @ ---------    ---------
 * @
 **/

@Controller
public class MainController {

    @Autowired
    private JoinService joinService;       //회원가입 / 로그인 / 아이디 찾기 관련 SERVICE.


    /**
     * 로그인 정보 확인후, 있으면 메인화면 없으면 로그인화면
     **/
    @RequestMapping("/")
    public void MainIndex(HttpServletResponse response, HttpServletRequest request) throws Exception {

        PrintWriter writer = response.getWriter();
        HttpSession session = request.getSession();
        Object result = session.getAttribute("userId");

        if (result == null) {
            writer.println("<script>location.href=\"login.do\";</script>");
        }
        //로그인 세션정보 있을 시 바로 메인으로 이동
        else {
            writer.println("<script>location.href=\"main.do\";</script>");
        }
    }

    //메뉴
    @RequestMapping("/menu")
    public String menu(){
        return "menu";
    }

    //메인
    @RequestMapping("/main")
    public String main(){
        return "main";
    }

    //로그인
    @RequestMapping("/login")
    public String login(HttpSession session){
        session.invalidate();
        return "login";
    }

    //로그인 요청
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public @ResponseBody String getLogin(@ModelAttribute("joinVO") JoinVO joinVO, HttpServletRequest request) throws Exception {

        System.out.println("joinVo  --> " + joinVO);
        EgovMap egovMap = joinService.userLoginSelect(joinVO);     //로그인 CALL.
        String result = "";

        if (egovMap != null) {
            System.out.println(egovMap.get("userType"));
            //일반 사용자 로그인 시도시 authFail
            if(egovMap.get("userType").equals("001"))  return "authFail";

            HttpSession session = request.getSession();
            session.setAttribute("userId", egovMap.get("userId"));
            session.setAttribute("userName", egovMap.get("userName"));

        } else {
            //로그인 정보 잘못되면 authFail
            result = "wrongFail";
        }

        return result;
    }
}
