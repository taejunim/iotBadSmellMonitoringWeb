package iotBadSmellMonitoring.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MemberController {
    //회원관리
    @RequestMapping("/member")
    public String menu(){
        return "memberManagement";
    }
}
