package iotBadSmellMonitoring.statistic;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @ Class Name   : Statistic.java
 * @ Modification : Statistic CONTROLLER (통계)
 * @
 * @ 최초 생성일  최초 생성자
 * @ ---------    ---------
 * @ 2021.06.08.    조유영
 * @
 * @ 수정일        수정자
 * @ ---------    ---------
 * @
 **/
@Controller
public class StatisticController {
    //통계
    @RequestMapping("/statistic")
    public String statistic(){
        return "statistic";
    }

}
