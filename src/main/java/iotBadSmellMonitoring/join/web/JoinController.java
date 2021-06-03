package iotBadSmellMonitoring.join.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @ Class Name   : JoinController.java
 * @ Modification : 회원가입 / 아이디 찾기 관련 COTROLLER
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

    //회원가입
    @RequestMapping("/join")
    public String menu(){
        return "join";
    }
}
