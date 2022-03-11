package iotBadSmellMonitoring.attend.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AttendController {

//    @Autowired
//    private AttendService attendService;

    //마이페이지 화면
    @RequestMapping("/attend")
    public String attend(){

        return "attend";
    }
}
