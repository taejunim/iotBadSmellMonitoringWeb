package iotBadSmellMonitoring.fileUploadSample;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UploadController {

    //파일업로드 화면
    @RequestMapping("/uploadTest")
    public String menu(){
        return "fileUploadSample";
    }

}
