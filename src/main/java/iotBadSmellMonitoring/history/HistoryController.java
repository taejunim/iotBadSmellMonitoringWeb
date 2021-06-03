package iotBadSmellMonitoring.history;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HistoryController {
    //개별접수이력조회
    @RequestMapping("/history")
    public String menu(){
        return "history";
    }
}
