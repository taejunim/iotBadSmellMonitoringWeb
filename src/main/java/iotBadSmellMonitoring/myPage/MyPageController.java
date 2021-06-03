package iotBadSmellMonitoring.myPage;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MyPageController {
    //마이페이지
    @RequestMapping("/myPage")
    public String menu(){
        return "myPage";
    }
}
