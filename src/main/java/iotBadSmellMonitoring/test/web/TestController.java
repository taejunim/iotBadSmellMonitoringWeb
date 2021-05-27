package iotBadSmellMonitoring.test.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import iotBadSmellMonitoring.test.service.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
public class TestController {

    @Autowired
    private TestService testService;

    @RequestMapping("/")
    public String test(){

        List<EgovMap> test = testService.selectTest();

        System.out.println("결과 ---> " + test);
        return "index";
    }
}
