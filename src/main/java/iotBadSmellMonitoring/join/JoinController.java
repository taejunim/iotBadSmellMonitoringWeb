package iotBadSmellMonitoring.join;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class JoinController {
    //회원가입
    @RequestMapping("/join")
    public String menu(){
        return "join";
    }
}
