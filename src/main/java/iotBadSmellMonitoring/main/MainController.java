package iotBadSmellMonitoring.main;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
    public String login(){
        return "login";
    }

    //회원관리
    @RequestMapping("/memberManagement")
    public String memberManagement(){

        return "memberManagement";
    }
}
