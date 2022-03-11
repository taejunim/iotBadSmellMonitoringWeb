package iotBadSmellMonitoring.notice.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class NoticeController {

//    @Autowired
//    private NoticeService noticeService;

    //마이페이지 화면
    @RequestMapping("/notice")
    public String notice(){

        return "notice";
    }
}
